check_java_apps() {

    # -----------------------------
    # MAPA ALIASÓW (TU DODAJESZ NAZWY)
    # -----------------------------
    declare -A ALIAS_MAP=(
        ["org.apache.catalina.startup.Bootstrap"]="TOMCAT"
        ["my.app.Main"]="BoFa"
        ["com.example.OrdersApp"]="Orders"
        ["kafka.Kafka"]="KAFKA"
    )

    # -----------------------------
    # LOGIKA
    # -----------------------------
    jps -lv | while read -r line; do
        pid=$(echo "$line" | awk '{print $1}')
        main=$(echo "$line" | awk '{print $2}')
        jar=$(echo "$line" | grep -o '[^ ]*\.jar' | head -n1)

        alias="${ALIAS_MAP[$main]:-UNKNOWN}"

        # OUTPUT — jedna linia
        if [ -n "$jar" ]; then
            echo "$pid | $alias | $main | $jar"
        else
            echo "$pid | $alias | $main"
        fi
    done
}
