sed -i -E 's/,?rsa-sha2-(512|256)(-cert-v01@openssh\.com)?//g; s/,?ssh-rsa(-cert-v01@openssh\.com)?//g' sshd_config


grep -E "^HostKeyAlgorithms|^PubkeyAcceptedKeyTypes" sshd_config


/usr/sbin/sshd -t -f /etc/ssh/sshd_config
