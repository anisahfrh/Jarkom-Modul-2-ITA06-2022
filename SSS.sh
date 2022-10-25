echo "
nameserver 192.168.122.1
nameserver 192.212.1.2
nameserver 192.212.3.2
"> /etc/resolv.conf
apt-get update -y
apt-get install lynx -y
apt-get install dnsutils -y