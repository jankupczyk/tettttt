system("grep -v -E '^(Name|----|Length|=+)\$' raport.txt | grep -v '^\\s*\$' > raport_tmp && mv raport_tmp raport.txt");
