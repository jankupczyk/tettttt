#!/usr/bin/env python3
"""
Parser dla plikow wyjsciowych skryptu monitorujacego indeksy Informix
(np. i_rach_konv_i.out), generowanych przez petle typu:

    date
    echo "$sql" | dbaccess sysmaster
    sleep N
    (powtorz)

Format pliku:
    Tue Aug 11 10:37:13 CEST 2026
    4197106 slink   i3_rach_konwersja   0     0    0   0     0   0 0 0
    4194436 slink   i1_rach_konwersja   12044 0    6725 0    4015 0 0 0
    ...
    Tue Aug 11 10:37:30 CEST 2026
    ...

Kolejnosc kolumn liczbowych domyslnie odpowiada kolejnosci z zapytania SQL
w skrypcie monitorujacym (dbaccess sysptprof):
    bufreads, bufwrites, lockreqs, lockwts, isreads, iswrites,
    isrewrites, isdeletes, seqscans

Jesli w Twoim pliku jest inna liczba kolumn (np. 8 zamiast 9, bo seqscans
zawsze wynosi 0 i zostal obciety w terminalu), dostosuj liste METRIC_NAMES
ponizej tak, aby jej dlugosc odpowiadala liczbie kolumn w danych.

Uzycie:
    python3 parse_index_usage.py i_rach_konv_i.out
    python3 parse_index_usage.py i_rach_konv_i.out --metric isreads
    python3 parse_index_usage.py i_rach_konv_i.out --metric bufreads --out moj_wykres.png

Wyjscie:
    <plik>.csv   - dane w formacie dlugim (timestamp, partnum, tabname, index, metric, value)
    <plik>.png   - wykres liniowy dla wybranej metryki, jedna linia na indeks
"""

import argparse
import csv
import re
import sys
from pathlib import Path

# Dostosuj kolejnosc/liczbe kolumn do swojego skryptu monitorujacego
METRIC_NAMES = [
    "bufreads", "bufwrites", "lockreqs", "lockwts",
    "isreads", "iswrites", "isrewrites", "isdeletes", "seqscans",
]

TIMESTAMP_RE = re.compile(
    r"^\w{3}\s+\w{3}\s+\d{1,2}\s+\d{2}:\d{2}:\d{2}\s+\w+\s+\d{4}\s*$"
)
DATA_RE = re.compile(
    r"^(\d+)\s+(\S+)\s+(\S+)\s+((?:-?\d+\s*)+)$"
)


def parse_file(path):
    rows = []
    current_ts = None
    with open(path, "r", errors="replace") as f:
        for line in f:
            line = line.rstrip("\n")
            if not line.strip():
                continue
            if TIMESTAMP_RE.match(line.strip()):
                current_ts = line.strip()
                continue
            m = DATA_RE.match(line.strip())
            if m and current_ts:
                partnum, tabname, indexname, values_str = m.groups()
                values = [int(v) for v in values_str.split()]
                names = METRIC_NAMES[: len(values)]
                for name, val in zip(names, values):
                    rows.append({
                        "timestamp": current_ts,
                        "partnum": partnum,
                        "tabname": tabname,
                        "index": indexname,
                        "metric": name,
                        "value": val,
                    })
    return rows


def write_csv(rows, out_path):
    with open(out_path, "w", newline="") as f:
        writer = csv.DictWriter(
            f, fieldnames=["timestamp", "partnum", "tabname", "index", "metric", "value"]
        )
        writer.writeheader()
        writer.writerows(rows)


def plot_metric(rows, metric, out_path):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    filtered = [r for r in rows if r["metric"] == metric]
    if not filtered:
        print(f"Brak danych dla metryki '{metric}'. Dostepne metryki: "
              f"{sorted(set(r['metric'] for r in rows))}")
        sys.exit(1)

    timestamps = sorted(set(r["timestamp"] for r in filtered),
                         key=lambda t: filtered[0]["timestamp"])
    # zachowaj kolejnosc wystapien w pliku, nie alfabetyczna
    seen = []
    for r in filtered:
        if r["timestamp"] not in seen:
            seen.append(r["timestamp"])
    timestamps = seen

    indexes = sorted(set(r["index"] for r in filtered))

    series = {idx: [] for idx in indexes}
    for ts in timestamps:
        vals_at_ts = {r["index"]: r["value"] for r in filtered if r["timestamp"] == ts}
        for idx in indexes:
            series[idx].append(vals_at_ts.get(idx, 0))

    plt.figure(figsize=(11, 5))
    for idx in indexes:
        plt.plot(timestamps, series[idx], marker="o", markersize=3, label=idx)

    plt.title(f"{metric} w czasie — per indeks")
    plt.xlabel("czas")
    plt.ylabel(metric)
    plt.xticks(rotation=45, ha="right", fontsize=8)
    plt.legend()
    plt.grid(True, alpha=0.3)
    plt.tight_layout()
    plt.savefig(out_path, dpi=150)
    print(f"Zapisano wykres: {out_path}")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("input_file", help="Plik wyjsciowy monitora, np. i_rach_konv_i.out")
    ap.add_argument("--metric", default="isreads", help="Metryka do wykresu (domyslnie: isreads)")
    ap.add_argument("--out", default=None, help="Sciezka do pliku PNG (domyslnie: <input>.png)")
    ap.add_argument("--csv-only", action="store_true", help="Wygeneruj tylko CSV, bez wykresu")
    args = ap.parse_args()

    in_path = Path(args.input_file)
    rows = parse_file(in_path)
    if not rows:
        print("Nie znaleziono zadnych danych - sprawdz format pliku / wyrazenia regularne.")
        sys.exit(1)

    csv_path = in_path.with_suffix(".csv")
    write_csv(rows, csv_path)
    print(f"Zapisano CSV: {csv_path} ({len(rows)} wierszy)")

    if not args.csv_only:
        out_png = Path(args.out) if args.out else in_path.with_suffix(".png")
        plot_metric(rows, args.metric, out_png)


if __name__ == "__main__":
    main()

