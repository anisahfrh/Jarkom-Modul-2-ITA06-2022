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

## Soal 7
Untuk informasi yang lebih spesifik mengenai Operation Strix, buatlah subdomain melalui Berlint dengan akses strix.operation.wise.yyy.com dengan alias www.strix.operation.wise.yyy.com yang mengarah ke Eden 

### Penyelesaian 7 
Di Berlin, kami menambahkan konfigurasi pada `/etc/bind/operation/operation.wise.ita06.com`
```
echo "\$TTL    604800
@       IN      SOA     operation.wise.ita06.com. root.operation.wise.ita06.com. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@               IN      NS      operation.wise.ita06.com.
@               IN      A       192.212.3.3			;IP Eden
www             IN      CNAME   operation.wise.ita06.com.
strix		IN	A	192.212.3.3			;IP Eden
www.strix	IN	CNAME	strix.operation.wise.ita06.com. " > /etc/bind/operation/operation.wise.ita06.com
```
Kami menambahkan domain strix dan alias www.strix untuk strix.operation.wise.ita06.com yang mengarah ke Eden

**Testing**

![testing8](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc05.PNG)

## Soal 8
Setelah melakukan konfigurasi server, maka dilakukan konfigurasi Webserver. Pertama dengan webserver www.wise.yyy.com. Pertama, Loid membutuhkan webserver dengan DocumentRoot pada /var/www/wise.yyy.com 

### Penyelesaian 8
- Pertama-tama  menginstall apache2 `apt-get install apache2 -y`
- Lalu membuat directory wise.ita06.com di `var/www/` 
- Kemudian melakukan konfigurasi file dari subdomain tersebut di `/etc/apache2/sites-available/wise.ita06.com.conf`  dan mengisinya dengan
```
ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.ita06.com
        ServerName wise.ita06.com
        ServerAlias wwww.wise.ita06.com
```
Sehingga DocumentRoot dari subdomain www.wise.yyy.com akan terletak di `/var/www/wise.ita06.com`

**Testing**

Jika di lynx dari SSS maka akan menampilkan isi dari /var/www/wise.ita06.com.

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156b05.PNG)


## Soal 9
Setelah itu, Loid juga membutuhkan agar url www.wise.yyy.com/index.php/home dapat menjadi www.wise.yyy.com/home 

### Penyelesaian 9
Di dalam `/etc/apache2/sites-available/wise.ita06.com.conf` kami menambahkan syntax 'Alias "/home" "/var/www/wise.ita06.com/index.php/home"` agar membuat `/index.php/home` berpindah ke `/home` 

**Testing**

Berikut merupakan tampilan jika kita membuka url www.wise.ita06.com/home yang isinya sama seperti soal 8


## Soal 10
Setelah itu, pada subdomain www.eden.wise.yyy.com, Loid membutuhkan penyimpanan aset yang memiliki DocumentRoot pada /var/www/eden.wise.yyy.com

### Penyelesaian 10
Di Eden, kami membuat directory baru `eden.wise.ita06.com` di dalam `/var/www/`
- Lalu melakukan perintah `wget` untuk mendapatkan file asset, 
- Setelah file terdownload maka akan langsung terunzip menggunakan command `unzip` dan memindahkan isi folder asset dan menghapus defaultnya
- Di dalam `/etc/apache2/sites-available/` dibuat juga file dengan nama `eden.wise.ita06.com.conf` dan diisi dengan
```
	ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.ita06.com
        ServerName eden.wise.ita06.com
        ServerAlias www.eden.wise.ita06.com
```

Sehingga DocumentRoot dari subdomain www.eden.wise.ita06.com akan terletak di  `/var/www/eden.wise.ita06.com.`

**Testing**

Jika kita lynx ke www.eden.wise.ita06.com maka akan menampilkan isi dari  /var/www/eden.wise.ita06.com dan bisa dilihat juga bahwa isi dari domain tersebut adalah public yang berisikan asset

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)

## Soal 11
Akan tetapi, pada folder /public, Loid ingin hanya dapat melakukan directory listing saja

### Penyelesaian 11
Di Eden, kami menambahkan konfigurasi pada `/etc/apache2/sites-available/eden.wise.ita06.com.conf ` untuk membuat directory listing
```
	<Directory /var/www/eden.wise.ita06.com/public>
                Options +Indexes
        </Directory>
```
 
**Testing**

Bisa dilihat jika kita me-lynx ke www.eden.wise.ita06.com maka akan menampilkan directory listing

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)

## Soal 12
Tidak hanya itu, Loid juga ingin menyiapkan error file 404.html pada folder /error untuk mengganti error kode pada apache 

### Penyelesaian 12
Di Eden, kami mengubah konfigurasi file pada `/etc/apache2/sites-avaiable/eden.wise.ita06.com.conf`
```
ErrorDocument 404 /error/404.html
        <Files "/var/www/eden.wise.ita06.com/error/404.html">
                <if \"-z %{ENV:REDIRECT_STATUS}\">
                        RedirectMatch 404 ^/error/404.html$
                </if>
        </Files>
```
Kami menambahkan ErrorDocument dan Files sehingga jika muncul error code 404 maka akan mengarah ke file 404 yang ada yaitu `/error/404.html`

**Testing**

Kemudian melakukan lynx untuk mengetest pada link directory yang tidak ada sehingga nanti akan mengeluarkan error 404 
```
lynx eden.wise.ita06.com/abcd 
```
 
Maka hasilnya akan seperti ini

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)

 
## Soal 13
Loid juga meminta Franky untuk dibuatkan konfigurasi virtual host. Virtual host ini bertujuan untuk dapat mengakses file asset www.eden.wise.yyy.com/public/js menjadi www.eden.wise.yyy.com/js

### Penyelesaian 13
 
**Eden**

kami mengubah konfigurasi pada `/etc/apache2/sites-available/eden.wise.ita06.com.conf` 
```
Alias "/js" "/var/www/eden.wise.ita06.com/public/js"
```

Fungsi `alias` akan menerjemahkan direkori web `/js` menjadi `/public/js`
 
**Testing**

Selanjutnya melakukan lynx pada SSS dan Garden untuk melihat isi dari www.eden.wise.ita06.com/js 
lynx eden.wise.ita06.com/js 
 
Maka hasilnya akan seperti ini
 
## Soal 14
Loid meminta agar www.strix.operation.wise.yyy.com hanya bisa diakses dengan port 15000 dan port 15500

### Penyelesaian 14

**Eden**

Kami memasukkan port 15000 dan port 15500 di `/etc/apache2/sites-avaiable/strix.operation.wise.ita06.com.conf`
sehingga web www.strix.operation.wise.ita06.com hanya bisa diakses menggunakan port 15000 dan port 15500
```
<VirtualHost *:15000 *:15500>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.ita06.comq
        ServerName strix.operation.wise.ita06.com
        ServerAlias www.strix.operation.wise.ita06.com

        <Directory "/var/www/strix.operation.wise.ita06.com">
                AuthType Basic
                AuthName "Restricted Content"
                AuthUserFile /var/www/strix.operation.wise.ita06/.htpasswd
                Require valid-user
                Options +Indexes
        </Directory>

        Alias "/home" "/var/www/wise.ita06.com/index.php/home"

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
```

**Testing**

Selanjutnya kita melakukan `lynx` di SSS dan Garden untuk mengecek jika menggunakan port 15000 dan port 15500
```
lynx strix.operation.wise.ita06.com:15000 
```
dan
```
lynx strix.operation.wise.ita06.com:15500 
```

Maka tampilannya akan seperti berikut

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)


## Soal 15
dengan autentikasi username Twilight dan password opStrix dan file di /var/www/strix.operation.wise.yyy 

### Penyelesaian 15

**Eden** 

Kami menggunakan command 
`htpasswd -i -c /var/www/strix.operation.wise.ita06/.htpasswd Twilight opStrix`
untuk mengatur basic authentication yang tersimpan di file `/var/www/strix.operation.wise.ita06` dengan username Twilight dan password opStrix

**Testing**

Selanjutnya melakukan lynx untuk testing
`lynx strix.operation.wise.ita06.com:15000`
 
![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)

Kemudian kita akan diminta memasukkan username dan password, jika benar maka tampilannya seperti berikut:

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)
 
## Soal 16
dan setiap kali mengakses IP Eden akan dialihkan secara otomatis ke www.wise.yyy.com

### Penyelesaian 16

**Eden**

Kami menambahkan `redirect permanent/http://wise.ita06.com` di file `/etc/apache2/sites-available/000-default.conf`
```
<VirtualHost *:80>
 
        redirect permanent / http://wise.ita06.com
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
 
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Sehingga ketika mengakses IP Eden maka akan langsung dialihkan secara automatis ke www.wise.it06.com 

**Testing**

Selanjutnya kita cek dengan melakukan `lynx` diikuti dengan IP dari Eden

```
lynx 192.212.3.3
```
Maka akan langsung dialihkan ke web www.wise.it06.com

![testing88](https://user-images.githubusercontent.com/76768695/198831285-dde48316-1b16-43e8-9e06-175d9156bc0.PNG)
 
## Soal 17
Karena website www.eden.wise.yyy.com semakin banyak pengunjung dan banyak modifikasi sehingga banyak gambar-gambar yang random, maka Loid ingin mengubah request gambar yang memiliki substring “eden” akan diarahkan menuju eden.png. Bantulah Agent Twilight dan Organisasi WISE menjaga perdamaian! 

### Penyelesaian 17
Di Eden kami membuat file di `/var/www/eden.wise.ita06.com/.htaccess`
```
RewriteEngine On
RewriteCond %{REQUEST_URI} !^/public/images/eden.png$
RewriteCond %{REQUEST_FILENAME} !-d 
RewriteRule ^(.*)eden(.*)$ /public/images/eden.png [R=301,L]
```
yang berisi jika apapun yang memiliki string “eden” maka akan diarahkan menuju /public/images/eden.png

**Testing**




## Kendala Pengerjaan
