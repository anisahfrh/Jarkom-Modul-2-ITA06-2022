echo nameserver 192.168.122.1 > /etc/resolv.conf
apt-get update -y
apt-get install bind9 -y
echo "
zone \"wise.ita06.com\" {
	type master;
	notify yes;
	also-notify { 192.212.3.2; };
	allow-transfer { 192.212.3.2; };
	file \"/etc/bind/wise/wise.ita06.com\";
};

zone \"1.212.192.in-addr.arpa\" {
	type master;
	file \"/etc/bind/wise/1.212.192.in-addr.arpa\";
};

"> /etc/bind/named.conf.local

mkdir -p /etc/bind/wise

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     wise.ita06.com. root.wise.ita06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      wise.ita06.com.
@               IN      A       192.212.1.2
www             IN      CNAME   wise.ita06.com.
eden            IN      A       192.212.3.3
www.eden        IN      CNAME   eden.wise.ita06.com.
ns1             IN      A       192.212.3.2
operation       IN      NS      ns1
@		IN	AAAA	::1

"> /etc/bind/wise/wise.ita06.com

echo "
options {
        directory \"/var/cache/bind\";
        // If there is a firewall between you and nameservers you want
        // to talk to, you may need to fix the firewall to allow multiple
        // ports to talk.  See http://www.kb.cert.org/vuls/id/800113
        // If your ISP provided one or more IP addresses for stable 
        // nameservers, you probably want to use them as forwarders.  
        // Uncomment the following block, and insert the addresses replacing 
        // the all-0's placeholder.
        // forwarders {
        //      0.0.0.0;
        // };
        //========================================================================
        // If BIND logs error messages about the root key being expired,
        // you will need to update your keys.  See https://www.isc.org/bind-keys
        //========================================================================
        //dnssec-validation auto;
        allow-query{any;};

        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options

echo "
;
; BIND data file for local loopback interface
;
\$TTL    604800
@       IN      SOA     wise.ita06.com. root.wise.ita06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
1.212.192.in-addr.arpa. IN      NS      wise.ita06.com.
2                       IN      PTR     wise.ita06.com.
" > /etc/bind/wise/1.212.192.in-addr.arpa

service bind9 restart