check_java_apps() {

    declare -A ALIAS_MAP=(
        ["org.apache.catalina.startup.Bootstrap"]="TOMCAT"
        ["my.app.Main"]="BoFa"
        ["com.example.OrdersApp"]="Orders"
        ["kafka.Kafka"]="KAFKA"
        ["org.apache.zookeeper.server.quorum.QuorumPeerMain"]="ZOOKEEPER"
    )
    declare -A JAR_MAP=(
        ["app-1.2.3.jar"]="BoFa"
        ["bootstrap.jar"]="TOMCAT"
    )

    jps -lv | while read -r line; do
        pid=$(echo "$line" | awk '{print $1}')
        main=$(echo "$line" | awk '{print $2}')
        jar=$(echo "$line" | grep -o '[^ ]*\.jar' | head -n1)

        alias="UNKNOWN"

        if [[ -n "${ALIAS_MAP[$main]}" ]]; then
            alias="${ALIAS_MAP[$main]}"
        fi

        if [[ "$alias" == "UNKNOWN" && -n "$jar" && -n "${JAR_MAP[$jar]}" ]]; then
            alias="${JAR_MAP[$jar]}"
        fi

        if [ -n "$jar" ]; then
            echo "$pid | $alias | $main | $jar"
        else
            echo "$pid | $alias | $main"
        fi
    done
}
