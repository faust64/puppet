# Local definitions go there

host hesperus-vlan2 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.242.12;
}

host oneiroi-br0 {
    hardware ethernet 00:1a:4d:53:52:f5;
    fixed-address 10.42.242.102;
}

host cerberus-eth0 {
    hardware ethernet 04:18:d6:54:03:b2;
    fixed-address 10.42.242.26;
}

host momos-br0 {
    hardware ethernet 00:24:81:b4:3c:8e;
    fixed-address 10.42.242.103;
}

host nyx-em1 {
    hardware ethernet 38:ea:a7:a9:2d:5c;
    fixed-address 10.42.242.20;
}

host oneiroi-br1 {
    hardware ethernet a0:36:9f:04:45:d4;
    fixed-address 10.42.46.102;
}

host hesperus-vlan42 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.42.12;
}

host netserv-eth0 {
    hardware ethernet 52:54:00:f5:a3:ff;
    fixed-address 10.42.44.100;
}

host hesperus-vlan7 {
    hardware ethernet 00:08:9b:c4:6c:62;
    fixed-address 10.42.43.12;
}

host reverse-eth0 {
    hardware ethernet 02:00:0a:2a:f2:15;
    fixed-address 10.42.242.21;
}

host selene-em1 {
    hardware ethernet 9c:b6:54:04:5a:88;
    fixed-address 10.42.242.16;
}

host eos-em1 {
    hardware ethernet 9c:b6:54:0b:17:d5;
    fixed-address 10.42.242.18;
}

host helios-em1 {
    hardware ethernet 9c:b6:54:02:37:c8;
    fixed-address 10.42.242.14;
}

host monitor-eth0 {
    hardware ethernet 02:00:0a:2a:f2:c8;
    fixed-address 10.42.242.200;
}

host nemesis-br0 {
    hardware ethernet 30:85:a9:45:ef:b4;
    fixed-address 10.42.242.100;
}

host momos-br1 {
    hardware ethernet a0:36:9f:04:44:cb;
    fixed-address 10.42.46.103;
}

host hemara-em1 {
    hardware ethernet 9c:b6:54:0b:11:e6;
    fixed-address 10.42.242.19;
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

host thanatos-br0 {
    hardware ethernet 30:85:a9:45:ef:bc;
    fixed-address 10.42.242.101;
}

host moros-br0 {
    hardware ethernet 00:24:81:26:b4:4d;
    fixed-address 10.42.242.104;
}

host moros-br1 {
    hardware ethernet a0:36:9f:04:46:7c;
    fixed-address 10.42.46.104;
}

host thanatos-br1 {
    hardware ethernet a0:36:9f:04:44:d7;
    fixed-address 10.42.46.101;
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

host erebe-eth0 {
    hardware ethernet 38:ea:a7:a1:10:da;
    fixed-address 10.42.242.22;
}

host hemara-eth0 {
    hardware ethernet 9c:b6:54:0b:11:e6;
    fixed-address 10.42.242.19;
}

host nyx-eth0 {
    hardware ethernet 38:ea:a7:a9:2d:5c;
    fixed-address 10.42.242.20;
}

host helios-eth0 {
    hardware ethernet 9c:b6:54:02:37:c8;
    fixed-address 10.42.242.14;
}

host aether-eth1 {
    hardware ethernet b0:5a:da:87:f3:10;
    fixed-address 10.42.46.16;
}

host selene-eth0 {
    hardware ethernet 9c:b6:54:04:5a:88;
    fixed-address 10.42.242.16;
}

host erebe-eth1 {
    hardware ethernet 2c:27:d7:15:87:d5;
    fixed-address 10.42.46.15;
}

host aether-eth2 {
    hardware ethernet b0:5a:da:87:f3:11;
    fixed-address 10.42.242.23;
}

host ouranos-eth0 {
    hardware ethernet 38:ea:a7:a4:9a:84;
    fixed-address 10.42.242.24;
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
