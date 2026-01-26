for m in GET POST PUT DELETE PATCH OPTIONS; do
  echo "== $m =="
  curl -k -s -o /dev/null -w "%{http_code}\n" -X $m https://host/api
done
