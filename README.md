# EnterpriseAppUpdater

Enterprise-grade PowerShell application updater for Windows environments using centralized internal SMB software repositories.

---

# Overview

EnterpriseAppUpdater is a lightweight PowerShell-based software deployment and update agent.

It automatically:

- detects installed applications,
- scans centralized software repository,
- compares versions,
- installs newer versions silently,
- validates installers,
- logs all operations,
- supports rollback preparation.

The updater is designed for enterprise environments where applications are centrally published on SMB shares.

---

# Key Features

## Core Features

- Centralized application updates from SMB share
- Silent EXE/MSI installation
- Installed application inventory detection
- Version comparison engine
- Multiple version detection strategies
- Authenticode signature validation
- Logging and auditing
- Rollback metadata preparation
- Simulation mode
- Parallel-safe architecture
- Task Scheduler ready
- Browser auto-updates
- Read-only repository access
- Enterprise-safe whitelist architecture

---

# Repository Structure

```text
\\wro01scl\install\Aplikacje\
│
├── <GŁÓWNY KATALOG>\
│   └── <APLIKACJA>\
│       └── Live\
│           └──<INSTALKA>
```

---

# Local Structure

```text
C:\ProgramData\EnterpriseAppUpdater\
│
├── Config\
├── Logs\
├── Rollback\
├── Temp\
```

---

# Installation

## Create directories

```powershell
Pobierz plik WinAppUpdater.zip i rozpakuj w lokalizacji "C:\ProgramData\EnterpriseAppUpdater"
```

---

# Running

## Standard

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\ProgramData\EnterpriseAppUpdater\Scripts\Update-Applications.ps1"
```

## Dry run

```powershell
powershell.exe -ExecutionPolicy Bypass -File "C:\ProgramData\EnterpriseAppUpdater\Scripts\Update-Applications.ps1" -DryRunMode
```

---

# applications.json Example

```json
{
  "Global": {
    "InstallerShare": "\\\\wro01scl\\\\install\\\\Aplikacje",
    "EnableSignatureValidation": true,
    "EnableChecksumValidation": false
  },

  "Applications": [
    {
      "AppId": "NOTEPADPP",
      "FriendlyName": "Notepad++",
      "Folder": "N",
      "AppFolder": "Notepad++",
      "SearchPattern": "npp*.exe",
      "InstallerType": "EXE",
      "VersionSource": "Filename",
      "SilentArgs": "/S",
      "Enabled": true
    }
  ]
}
```

---

# Version Strategies

| Strategy | Description |
|---|---|
| Filename | Wersja aplikacji jest brana z nazwy pliku |
| ProductVersion | Wersja aplikacji jest brana z ProductVersion aplikacji |
| FileVersion | Wersja aplikacji jest brana z FileVersion aplikacji |

---

# Security

- Repository access is READ-ONLY
- Updater NEVER modifies repository
- Supports Authenticode validation
- Supports SHA256 validation
- Uses whitelist-only architecture

---

# Logging

```text
C:\ProgramData\EnterpriseAppUpdater\Logs\updater.log
```

---

# Task Scheduler

Recommended:
- Run as SYSTEM
- Run with highest privileges
- Every 6 hours

Arguments:

```text
-ExecutionPolicy Bypass -File "C:\ProgramData\EnterpriseAppUpdater\Scripts\Update-Applications.ps1"
```
