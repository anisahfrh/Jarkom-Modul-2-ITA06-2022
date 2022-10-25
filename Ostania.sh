echo nameserver 192.168.122.1 > /etc/resolv.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.212.0.0/16
apt-get update -y