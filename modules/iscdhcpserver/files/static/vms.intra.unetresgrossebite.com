# Local definitions go there

host dysnomia-vlan7 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.43.2;
}

host dysnomia-gre3 {
    hardware ethernet ;
    fixed-address 10.42.242.2;
}

host repository-eth3 {
    hardware ethernet 02:00:0a:2a:f2:fe;
    fixed-address 10.42.242.254;
}

host dysnomia-carp3 {
    hardware ethernet 00:00:5e:00:01:03;
    fixed-address 10.42.45.1;
}

host media-eth0 {
    hardware ethernet 02:00:0a:2a:2c:fc;
    fixed-address 10.42.44.252;
}

host dysnomia-gre2 {
    hardware ethernet ;
    fixed-address 172.16.42.1;
}

host media-eth2 {
    hardware ethernet 02:00:0a:2a:2b:fc;
    fixed-address 10.42.43.252;
}

host dysnomia-carp7 {
    hardware ethernet 00:00:5e:00:01:07;
    fixed-address 10.42.43.1;
}

host dysnomia-vlan8 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.41.2;
}

host dysnomia-carp11 {
    hardware ethernet 00:00:5e:00:01:0b;
    fixed-address 10.42.40.1;
}

host hesperus-vlan2 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.242.12;
}

host eos-bond0 {
    hardware ethernet a0:36:9f:04:43:e4;
    fixed-address 10.42.46.12;
}

host oneiroi-br0 {
    hardware ethernet 00:1a:4d:53:52:f5;
    fixed-address 10.42.242.102;
}

host cerberus-eth0 {
    hardware ethernet 04:18:d6:54:03:b2;
    fixed-address 10.42.242.26;
}

host dysnomia-vlan100 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.252.2;
}

host kibana-eth0 {
    hardware ethernet 02:00:0a:2a:f2:9c;
    fixed-address 10.42.242.156;
}

host dysnomia-carp2 {
    hardware ethernet 00:00:5e:00:01:02;
    fixed-address 10.42.242.1;
}

host vpn-eth0 {
    hardware ethernet 00:16:3e:58:d0:ff;
    fixed-address 10.42.44.38;
}

host dysnomia-vlan42 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.42.2;
}

host storage-eth0 {
    hardware ethernet 02:00:0a:2a:2c:fd;
    fixed-address 10.42.44.253;
}

host ceph-eth0 {
    hardware ethernet 00:16:3e:0d:0d:06;
    fixed-address 10.42.46.42;
}

host dysnomia-carp100 {
    hardware ethernet 00:00:5e:00:01:64;
    fixed-address 10.42.252.1;
}

host momos-br0 {
    hardware ethernet 00:24:81:b4:3c:8e;
    fixed-address 10.42.242.103;
}

host dysnomia-gre1 {
    hardware ethernet ;
    fixed-address 10.42.242.2;
}

host nyx-em1 {
    hardware ethernet 38:ea:a7:a9:2d:5c;
    fixed-address 10.42.242.20;
}

host oneiroi-br1 {
    hardware ethernet a0:36:9f:04:45:d4;
    fixed-address 10.42.46.102;
}

host dysnomia-carp42 {
    hardware ethernet 00:00:5e:00:01:2a;
    fixed-address 10.42.42.1;
}

host hesperus-vlan42 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.42.12;
}

host dysnomia-carp6 {
    hardware ethernet 00:00:5e:00:01:06;
    fixed-address 10.42.254.1;
}

host oneiroi-virbr0 {
    hardware ethernet c2:9d:94:7b:47:6c;
    fixed-address 192.168.122.1;
}

host dysnomia-vlan4 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.44.2;
}

host inventory-eth0 {
    hardware ethernet 02:00:0a:2a:2c:30;
    fixed-address 10.42.44.48;
}

host nebula-eth0 {
    hardware ethernet 00:16:3e:79:97:9f;
    fixed-address 10.42.46.254;
}

host storage-eth1 {
    hardware ethernet 02:00:0a:2a:2a:fd;
    fixed-address 10.42.42.253;
}

host hemara-bond0 {
    hardware ethernet 2c:27:d7:15:9b:b1;
    fixed-address 10.42.46.13;
}

host netserv-eth0 {
    hardware ethernet 52:54:00:f5:a3:ff;
    fixed-address 10.42.44.100;
}

host hesperus-vlan7 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.43.12;
}

host dysnomia-vlan5 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.253.2;
}

host reverse-eth0 {
    hardware ethernet 02:00:0a:2a:f2:15;
    fixed-address 10.42.242.21;
}

host newznab-eth0 {
    hardware ethernet 00:16:3e:54:1f:1e;
    fixed-address 10.42.44.13;
}

host deepthroat-eth0 {
    hardware ethernet 02:00:0a:2a:2c:28;
    fixed-address 10.42.44.40;
}

host selene-em1 {
    hardware ethernet 9c:b6:54:04:5a:88;
    fixed-address 10.42.242.16;
}

host cronos-vlan1002 {
    hardware ethernet b8:27:eb:2c:81:fa;
    fixed-address 192.168.1.253;
}

host play-eth0 {
    hardware ethernet 02:00:0a:2a:2c:1b;
    fixed-address 10.42.44.27;
}

host muninone-eth0 {
    hardware ethernet 00:16:3e:7e:0d:f8;
    fixed-address 10.42.242.205;
}

host eos-em1 {
    hardware ethernet 9c:b6:54:0b:17:d5;
    fixed-address 10.42.242.18;
}

host nemesis-virbr0 {
    hardware ethernet 8a:71:c9:22:12:9f;
    fixed-address 192.168.122.1;
}

host helios-em1 {
    hardware ethernet 9c:b6:54:02:37:c8;
    fixed-address 10.42.242.14;
}

host dysnomia-vlan11 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.40.2;
}

host hesperus-vlan4 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.44.14;
}

host dysnomia-vlan2 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.242.2;
}

host media-eth1 {
    hardware ethernet 02:00:0a:2a:2a:fc;
    fixed-address 10.42.42.252;
}

host dysnomia-gre0 {
    hardware ethernet ;
    fixed-address 172.16.42.1;
}

host monitor-eth0 {
    hardware ethernet 02:00:0a:2a:f2:c8;
    fixed-address 10.42.242.200;
}

host nemesis-br0 {
    hardware ethernet 30:85:a9:45:ef:b4;
    fixed-address 10.42.242.100;
}

host repository-eth0 {
    hardware ethernet 02:00:0a:2a:2c:fe;
    fixed-address 10.42.44.254;
}

host dysnomia-carp8 {
    hardware ethernet 00:00:5e:00:01:08;
    fixed-address 10.42.41.1;
}

host dysnomia-gre9000 {
    hardware ethernet ;
    fixed-address 10.42.42.1;
}

host wiki-eth0 {
    hardware ethernet 02:00:0a:2a:2c:2a;
    fixed-address 10.42.44.42;
}

host storage-eth2 {
    hardware ethernet 02:00:0a:2a:2b:fd;
    fixed-address 10.42.43.253;
}

host repository-eth2 {
    hardware ethernet 02:00:0a:2a:2b:fe;
    fixed-address 10.42.43.254;
}

host dysnomia-carp9 {
    hardware ethernet 00:00:5e:00:01:09;
    fixed-address 109.190.111.166;
}

host repository-eth1 {
    hardware ethernet 02:00:0a:2a:2a:fe;
    fixed-address 10.42.42.254;
}

host dysnomia-carp1 {
    hardware ethernet 00:00:5e:00:01:01;
    fixed-address 82.237.197.209;
}

host dysnomia-vlan6 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.254.2;
}

host pki-eth0 {
    hardware ethernet 02:00:0a:2a:f2:c9;
    fixed-address 10.42.242.201;
}

host nyx-bond0 {
    hardware ethernet 2c:27:d7:15:ac:2e;
    fixed-address 10.42.46.14;
}

host dysnomia-carp10 {
    hardware ethernet 00:00:5e:00:01:0a;
    fixed-address 10.42.46.1;
}

host momos-br1 {
    hardware ethernet a0:36:9f:04:44:cb;
    fixed-address 10.42.46.103;
}

host dysnomia-vlan10 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.46.2;
}

host dysnomia-carp5 {
    hardware ethernet 00:00:5e:00:01:05;
    fixed-address 10.42.253.1;
}

host momos-virbr0 {
    hardware ethernet 0a:d6:ab:8d:a3:d6;
    fixed-address 192.168.122.1;
}

host dysnomia-carp4 {
    hardware ethernet 00:00:5e:00:01:04;
    fixed-address 10.42.44.1;
}

host hemara-em1 {
    hardware ethernet 9c:b6:54:0b:11:e6;
    fixed-address 10.42.242.19;
}

host asterisk-eth0 {
    hardware ethernet 02:00:0a:2a:29:fe;
    fixed-address 10.42.41.254;
}

host selene-bond0 {
    hardware ethernet 00:15:17:a7:9e:71;
    fixed-address 10.42.46.11;
}

host logmaster-eth0 {
    hardware ethernet 02:00:0a:2a:2c:10;
    fixed-address 10.42.44.16;
}

host nemesis-br1 {
    hardware ethernet a0:36:9f:04:45:e9;
    fixed-address 10.42.46.100;
}

host smtp-eth0 {
    hardware ethernet 02:00:0a:2a:2c:14;
    fixed-address 10.42.44.20;
}

host smokeping-eth0 {
    hardware ethernet 02:00:0a:2a:f2:ca;
    fixed-address 10.42.242.202;
}

host helios-bond0 {
    hardware ethernet 00:15:17:86:75:e1;
    fixed-address 10.42.46.10;
}

host dysnomia-vlan3 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 10.42.45.2;
}

host thanatos-br0 {
    hardware ethernet 30:85:a9:45:ef:bc;
    fixed-address 10.42.242.101;
}

host moros-br0 {
    hardware ethernet 00:24:81:26:b4:4d;
    fixed-address 10.42.242.104;
}

host moros-virbr0 {
    hardware ethernet 22:6e:f1:54:61:88;
    fixed-address 192.168.122.1;
}

host moros-br1 {
    hardware ethernet a0:36:9f:04:46:7c;
    fixed-address 10.42.46.104;
}

host thanatos-br1 {
    hardware ethernet a0:36:9f:04:44:d7;
    fixed-address 10.42.46.101;
}

host thanatos-virbr0 {
    hardware ethernet e6:34:cd:09:26:cc;
    fixed-address 192.168.122.1;
}

host eos-eth0 {
    hardware ethernet 9c:b6:54:0b:17:d5;
    fixed-address 10.42.242.18;
}

host erebe-p2p1 {
    hardware ethernet 2c:27:d7:15:87:d5;
    fixed-address 10.42.46.15;
}

host erebe-em1 {
    hardware ethernet 38:ea:a7:a1:10:da;
    fixed-address 10.42.242.22;
}

host peerio-eth0 {
    hardware ethernet 02:00:0a:2a:2c:31;
    fixed-address 10.42.44.49;
}

host jenkins-eth0 {
    hardware ethernet 02:00:0a:2a:2c:32;
    fixed-address 10.42.44.50;
}

host erebe-eth0 {
    hardware ethernet 38:ea:a7:a1:10:da;
    fixed-address 10.42.242.22;
}

host zeus-vlan3 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.45.5;
}

host zeus-vlan6 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.254.5;
}

host zeus-carp5 {
    hardware ethernet 00:00:5e:00:01:05;
    fixed-address 10.42.253.1;
}

host zeus-vlan10 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.46.5;
}

host zeus-gre0 {
    hardware ethernet ;
    fixed-address 172.16.42.4;
}

host zeus-carp11 {
    hardware ethernet 00:00:5e:00:01:0b;
    fixed-address 10.42.40.1;
}

host zeus-carp10 {
    hardware ethernet 00:00:5e:00:01:0a;
    fixed-address 10.42.46.1;
}

host zeus-gre2 {
    hardware ethernet ;
    fixed-address 172.16.42.4;
}

host zeus-carp3 {
    hardware ethernet 00:00:5e:00:01:03;
    fixed-address 10.42.45.1;
}

host zeus-vlan11 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.40.5;
}

host hemara-eth0 {
    hardware ethernet 9c:b6:54:0b:11:e6;
    fixed-address 10.42.242.19;
}

host zeus-gre3 {
    hardware ethernet ;
    fixed-address 10.42.242.5;
}

host zeus-carp7 {
    hardware ethernet 00:00:5e:00:01:07;
    fixed-address 10.42.43.1;
}

host zeus-carp4 {
    hardware ethernet 00:00:5e:00:01:04;
    fixed-address 10.42.44.1;
}

host nyx-eth0 {
    hardware ethernet 38:ea:a7:a9:2d:5c;
    fixed-address 10.42.242.20;
}

host zeus-carp9 {
    hardware ethernet 00:00:5e:00:01:09;
    fixed-address 109.190.111.166;
}

host helios-eth0 {
    hardware ethernet 9c:b6:54:02:37:c8;
    fixed-address 10.42.242.14;
}

host zeus-vlan7 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.43.5;
}

host zeus-vlan4 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.44.5;
}

host zeus-vlan100 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.252.5;
}

host zeus-vlan42 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.42.5;
}

host zeus-vlan2 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.242.5;
}

host zeus-carp2 {
    hardware ethernet 00:00:5e:00:01:02;
    fixed-address 10.42.242.1;
}

host aether-eth1 {
    hardware ethernet b0:5a:da:87:f3:10;
    fixed-address 10.42.46.16;
}

host zeus-gre1 {
    hardware ethernet ;
    fixed-address 10.42.242.5;
}

host zeus-carp1 {
    hardware ethernet 00:00:5e:00:01:01;
    fixed-address 82.237.197.209;
}

host zeus-carp6 {
    hardware ethernet 00:00:5e:00:01:06;
    fixed-address 10.42.254.1;
}

host zeus-carp42 {
    hardware ethernet 00:00:5e:00:01:2a;
    fixed-address 10.42.42.1;
}

host selene-eth0 {
    hardware ethernet 9c:b6:54:04:5a:88;
    fixed-address 10.42.242.16;
}

host zeus-carp12 {
    hardware ethernet 00:00:5e:00:01:0c;
    fixed-address 192.168.10.254;
}

host zeus-trunk0 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 172.16.42.4;
}

host zeus-carp100 {
    hardware ethernet 00:00:5e:00:01:64;
    fixed-address 10.42.252.1;
}

host zeus-vlan5 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.253.5;
}

host erebe-eth1 {
    hardware ethernet 2c:27:d7:15:87:d5;
    fixed-address 10.42.46.15;
}

host dysnomia-carp12 {
    hardware ethernet 00:00:5e:00:01:0c;
    fixed-address 192.168.10.254;
}

host zeus-vlan8 {
    hardware ethernet 00:00:24:d1:d7:f5;
    fixed-address 10.42.41.5;
}

host dysnomia-trunk0 {
    hardware ethernet 00:00:24:ca:3d:9d;
    fixed-address 172.16.42.1;
}

host aether-eth2 {
    hardware ethernet b0:5a:da:87:f3:11;
    fixed-address 10.42.242.23;
}

host zeus-carp8 {
    hardware ethernet 00:00:5e:00:01:08;
    fixed-address 10.42.41.1;
}

host makhai-carp3 {
    hardware ethernet 00:00:5e:00:01:03;
    fixed-address 10.42.45.1;
}

host makhai-carp11 {
    hardware ethernet 00:00:5e:00:01:0b;
    fixed-address 10.42.40.1;
}

host makhai-vlan8 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.41.4;
}

host makhai-gre2 {
    hardware ethernet ;
    fixed-address 172.16.42.3;
}

host makhai-vlan6 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.254.4;
}

host makhai-carp6 {
    hardware ethernet 00:00:5e:00:01:06;
    fixed-address 10.42.254.1;
}

host ouranos-eth0 {
    hardware ethernet 38:ea:a7:a4:9a:84;
    fixed-address 10.42.242.24;
}

host makhai-gre3 {
    hardware ethernet ;
    fixed-address 10.42.242.4;
}

host makhai-carp9 {
    hardware ethernet 00:00:5e:00:01:09;
    fixed-address 109.190.111.166;
}

host makhai-vlan100 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.252.4;
}

host makhai-carp7 {
    hardware ethernet 00:00:5e:00:01:07;
    fixed-address 10.42.43.1;
}

host makhai-vlan2 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.242.4;
}

host makhai-gre1 {
    hardware ethernet ;
    fixed-address 10.42.242.4;
}

host makhai-carp2 {
    hardware ethernet 00:00:5e:00:01:02;
    fixed-address 10.42.242.1;
}

host makhai-vlan10 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.46.4;
}

host makhai-trunk0 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 172.16.42.3;
}

host makhai-carp8 {
    hardware ethernet 00:00:5e:00:01:08;
    fixed-address 10.42.41.1;
}

host makhai-carp10 {
    hardware ethernet 00:00:5e:00:01:0a;
    fixed-address 10.42.46.1;
}

host ouranos-bond0 {
    hardware ethernet 00:15:17:cc:9f:29;
    fixed-address 10.42.46.17;
}

host makhai-gre0 {
    hardware ethernet ;
    fixed-address 172.16.42.3;
}

host makhai-carp1 {
    hardware ethernet 00:00:5e:00:01:01;
    fixed-address 82.237.197.209;
}

host makhai-vlan5 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.253.4;
}

host makhai-vlan3 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.45.4;
}

host makhai-carp12 {
    hardware ethernet 00:00:5e:00:01:0c;
    fixed-address 192.168.10.254;
}

host makhai-vlan42 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.42.4;
}

host makhai-vlan11 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.40.4;
}

host makhai-carp100 {
    hardware ethernet 00:00:5e:00:01:64;
    fixed-address 10.42.252.1;
}

host makhai-carp5 {
    hardware ethernet 00:00:5e:00:01:05;
    fixed-address 10.42.253.1;
}

host makhai-carp4 {
    hardware ethernet 00:00:5e:00:01:04;
    fixed-address 10.42.44.1;
}

host makhai-vlan7 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.43.4;
}

host makhai-vlan4 {
    hardware ethernet 00:00:24:cb:4e:99;
    fixed-address 10.42.44.4;
}

host makhai-carp42 {
    hardware ethernet 00:00:5e:00:01:2a;
    fixed-address 10.42.42.1;
}

host oizis-br0 {
    hardware ethernet a4:ba:db:0a:b7:ce;
    fixed-address 10.42.242.105;
}

host wifimgr-eth0 {
    hardware ethernet 00:16:3e:44:ba:e8;
    fixed-address 10.42.242.201;
}

host munin-eth0 {
    hardware ethernet 00:16:3e:41:3d:89;
    fixed-address 10.42.242.206;
}

host nyx-eth1 {
    hardware ethernet 2c:27:d7:15:ac:2e;
    fixed-address 10.42.46.14;
}

host thanatos-br10 {
    hardware ethernet a0:36:9f:04:44:d5;
    fixed-address 10.42.46.101;
}

host poseidon-eth0 {
    hardware ethernet 30:e1:71:b7:a4:47;
    fixed-address 10.42.44.150;
}
