FIXME:
  * init CA non exhaustive (missing core / build-inter)
```
root@pki# cd /pki_root/core_ca_root
root@pki# wget http://ftp.example.com/openssl.cnf -q -O openssl.cnf
root@pki# wget http://ftp.example.com/openssl-vars -q -O /root/vars
root@pki# touch index.txt ; echo 00 >serial
root@pki# build-ca
root@pki# build-dh
root@pki# build-inter openvpn
...
root@pki# build-inter auth
root@pki# mkdir ../openvpn ; cp -p openssl.cnf ../openvpn/ ; cd ../openvpn
root@pki# inherit-inter /pki_root/core_ca_root openvpn
root@pki# build-dh
root@pki# touch index.txt ; echo 00 >serial
...
root@pki# mkdir ../auth ; cp -p openssl.cnf ../auth/ ; cd ../auth
root@pki# inherit-inter /pki_root/core_ca_root auth
root@pki# build-dh
root@pki# touch index.txt ; echo 00 >serial
```
