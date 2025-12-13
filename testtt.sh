# Obliczamy datę początkową (teraz - 72h)
START_DATE=$(perl -e 'use POSIX qw(strftime); print strftime("%Y-%m-%d %H:%M:%S", localtime(time()-72*3600))')

# Obecny czas = data końcowa
END_DATE=$(date "+%Y-%m-%d %H:%M:%S")

echo "Report for transactions from $START_DATE to $END_DATE"
