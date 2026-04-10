echo $PATH


PATH=$(echo $PATH | sed 's/::/:/g' | sed 's/^\.://g' | sed 's/:\.//g')
export PATH


grep PATH ~/.profile ~/.kshrc /etc/profile


PATH=.:$PATH


PATH=$PATH


PATH=/usr/bin:/bin:/usr/sbin:/etc


. ~/.profile


echo $PATH | grep '\.'
