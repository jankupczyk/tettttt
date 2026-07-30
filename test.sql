sed -i -E 's/,?rsa-sha2-(512|256)(-cert-v01@openssh\.com)?//g; s/,?ssh-rsa(-cert-v01@openssh\.com)?//g' sshd_config


grep -E "^HostKeyAlgorithms|^PubkeyAcceptedKeyTypes" sshd_config


/usr/sbin/sshd -t -f /etc/ssh/sshd_config

sed 's/,\{0,1\}rsa-sha2-512-cert-v01@openssh\.com//g;
s/,\{0,1\}rsa-sha2-256-cert-v01@openssh\.com//g;
s/,\{0,1\}rsa-sha2-512//g;
s/,\{0,1\}rsa-sha2-256//g;
s/,\{0,1\}ssh-rsa-cert-v01@openssh\.com//g;
s/,\{0,1\}ssh-rsa//g' sshd_config > sshd_config.new
