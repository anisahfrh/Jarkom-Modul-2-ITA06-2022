# Jarkom-Modul-2-ITA06-2022

## <b> Anggota Kelompok: </b>
1. Anisah Farah Fadhilah - 5027201023
2. Banabil Fawazaim Muhammad - 5027201055
3. Shafira Khaerunnisa - 5027201072
---

## Soal 1
WISE akan dijadikan sebagai DNS Master, Berlint akan dijadikan DNS Slave, dan Eden akan digunakan sebagai Web Server. Terdapat 2 Client yaitu SSS, dan Garden. Semua node terhubung pada router Ostania, sehingga dapat mengakses internet

### Penyelesaian soal 1
Pertama, kami membuat topologi seperti pada soal. Hasilnya sebagai berikut.
![topologi](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/topologi.jpg)

Kemudian, melakukan konfigurasi untuk setiap node sebagai berikut

**Konfigurasi Ostania**
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.212.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.212.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.212.3.1
	netmask 255.255.255.0
```
**Konfigurasi WISE**
```
auto eth0
iface eth0 inet static
	address 192.212.1.2
	netmask 255.255.255.0
    gateway 192.212.1.1
```
**Konfigurasi SSS**
```
auto eth0
iface eth0 inet static
	address 192.212.2.2
	netmask 255.255.255.0
	gateway 192.212.2.1
```
**Konfigurasi Garden**
```
auto eth0
iface eth0 inet static
	address 192.212.2.3
	netmask 255.255.255.0
	gateway 192.212.2.1
```
**Konfigurasi Berlint**
```
auto eth0
iface eth0 inet static
	address 192.212.3.2
	netmask 255.255.255.0
	gateway 192.212.3.1
```
**Konfigurasi Eden**
```
auto eth0
iface eth0 inet static
	address 192.212.3.3
	netmask 255.255.255.0
	gateway 192.212.3.1
```

Setelah itu, pada konsol Ostania, kami memasukkan command
```
echo nameserver 192.168.122.1 > /etc/resolv.conf
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.212.0.0/16
```

Pada konsol node lainnya, kami memasukkan command
```
echo nameserver 192.168.122.1 > /etc/resolv.conf
```

**Testing**

![soal1](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal1.jpg)



## Soal 2
Untuk mempermudah mendapatkan informasi mengenai misi dari Handler, bantulah Loid membuat website utama dengan akses wise.yyy.com dengan alias www.wise.yyy.com pada folder wise

### Penyelesaian soal 2
Pertama, kami melakukan konfigurasi pada file `/etc/bind/named.conf.local`  sebagai berikut
```
zone "wise.ita06.com" {
	type master;
	file "/etc/bind/wise/wise.ita06.com";
};
```
Setelah itu, kami membuat direktori baru yaitu `/etc/bind/wise` di node **WISE** dan menuliskan konfigurasi berikut pada `/etc/bind/wise/wise.ita06.com`
```
;
; BIND data file for local loopback interface
;
$TTL    604800
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
```
Pada file konfigurasi diatas kami mengatur domain menjadi wise.ita06.com yang mengarah ke WISE dan membuat CNAME `www` sebagai alias dari `wise.ita06.com`

Terakhir, kami menambahkan `nameserver 192.212.1.2` ke dalam file `/etc/resolv.conf` pada node client **SSS** dan **Garden**

**Testing**

![soal2](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal2.jpg)



## Soal 3
Setelah itu ia juga ingin membuat subdomain eden.wise.yyy.com dengan alias www.eden.wise.yyy.com yang diatur DNS-nya di WISE dan mengarah ke Eden

### Penyelesaian soal 3
Kami menambahkan konfigurasi pada `/etc/bind/wise/wise.ita06.com` di node **WISE** sebagai berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
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
```
Pada file konfigurasi diatas kami menambahkan subdomain eden yang mengarah ke Eden dan membuat CNAME `www.eden` sebagai alias dari `eden.wise.ita06.com`

**Testing**

![soal3](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal3.jpg)



## Soal 4
Buat juga reverse domain untuk domain utama

### Penyelesaian soal 4
Untuk membuat reverse domain, kami menambahkan konfigurasi pada `/etc/bind/named.conf.local` di node **WISE** sebagai berikut
```
zone "1.212.192.in-addr.arpa" {
	type master;
	file "/etc/bind/wise/1.212.192.in-addr.arpa";
};
```
dan juga menambahkan konfigurasi pada `/etc/bind/wise/1.212.192.in-addr.arpa` di node **WISE** sebagai berikut
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     wise.ita06.com. root.wise.ita06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
1.212.192.in-addr.arpa. IN      NS      wise.ita06.com.
2                       IN      PTR     wise.ita06.com.
```
IP Address dari WISE adalah **192.212.1**.2, sehingga untuk reverse domainnya adalah **1.212.192**.in-addr.arpa

**Testing**

![soal4](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal4.jpg)



## Soal 5
Agar dapat tetap dihubungi jika server WISE bermasalah, buatlah juga Berlint sebagai DNS Slave untuk domain utama

### Penyelesaian soal 5
Untuk menjadikan Berlint sebagai DNS Slave, pada WISE, kami menambahkan konfigurasi `notify yes`, `also-notify { 192.217.2.3; }` serta `allow-transfer { 192.217.2.3; };` dalam file `/etc/bind/named.conf.local`, sehingga menjadi sebagai berikut


**WISE**
```
zone "wise.ita06.com" {
	type master;
	notify yes;
	also-notify { 192.212.3.2; };
	allow-transfer { 192.212.3.2; };
	file "/etc/bind/wise/wise.ita06.com";
};

zone "1.212.192.in-addr.arpa" {
	type master;
	file "/etc/bind/wise/1.212.192.in-addr.arpa";
};
```

Pada Berlint, dilakukan konfigurasi pada file `/etc/bind/named.conf.local` sebagai berikut


**Berlint**
```
zone "wise.ita06.com" {
    type slave;
    masters { 192.212.1.2; };
    file "/var/lib/bind/wise.ita06.com";
};
```

Terakhir, kami menambahkan `nameserver 192.212.3.2` ke dalam file `/etc/resolv.conf` pada node client **SSS** dan **Garden**

**Testing**

Kami mematikan service bind9 pada WISE dan menjalankan service bind9 pada Berlint
![soal5](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal5.jpg)



## Soal 6
Karena banyak informasi dari Handler, buatlah subdomain yang khusus untuk operation yaitu operation.wise.yyy.com dengan alias www.operation.wise.yyy.com yang didelegasikan dari WISE ke Berlint dengan IP menuju ke Eden dalam folder operation

### Penyelesaian soal 6
Pada WISE, kami melakukan konfigurasi pada `/etc/bind/wise/wise.ita06.com` sebagai berikut. Kami mendelegasikan NS1 dan subdomain operation ke alamat Berlint


**WISE**
```
;
; BIND data file for local loopback interface
;
$TTL    604800
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
```
Selain itu kami juga mengubah konfigurasi pada `/etc/bind/named.conf.options` dengan meng-*comment* `dnssec-validation auto;` dan menambahkan `allow-query{any;};`
```
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
```


Pada Berlint, kami melakukan konfigurasi pada file `/etc/bind/named.conf.local`sebagai berikut. Kami menambahkan zone untuk alamat operation.wise.ita06.com dengan type master dan folder konfigurasi nya terdapat pada folder operation

**Berlint**
```
zone "operation.wise.ita06.com" {
        type master;
        file "/etc/bind/operation/operation.wise.ita06.com";
};
```
Selain itu kami juga melakukan konfigurasi pada file `/etc/bind/named.conf.options` sama seperti milik WISE
```
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
```
Setelah itu, kami membuat direktori baru yaitu `/etc/bind/operation` di node **Berlint** dan menuliskan konfigurasi berikut pada `/etc/bind/operation/operation.wise.ita06.com`
```
;
; BIND data file for local loopback interface
;
$TTL    604800
@       IN      SOA     operation.wise.ita06.com. root.operation.wise.ita06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      operation.wise.ita06.com.
@               IN      A       192.212.3.3
www             IN      CNAME   operation.wise.ita06.com.
```
Pada file konfigurasi diatas kami mengatur domain operation.wise.ita06.com untuk mengarah ke Eden pada 192.212.3.3 dan membuat CNAME `www` sebagai alias dari `operation.wise.ita06.com`

**Testing**

![soal6](https://github.com/anisahfrh/Screenshot_Jarkom/raw/main/Modul2/soal6.jpg)


## Kendala Pengerjaan