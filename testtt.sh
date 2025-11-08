awk '/Thread-/{if(t){print t}; t=0} /at /{t++} END{print t}' /tmp/tomcat_jstack_YYYY-MM-DD_HH:MM:SS.txt | sort -nr | head
