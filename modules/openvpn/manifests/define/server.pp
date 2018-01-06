define openvpn::define::server($bridge  = "gre42",
			       $filter  = false,
			       $iface   = "tun0",
			       $monitor = true,
			       $netmsk  = 24,
			       $network = "127.0.0.1",
			       $proto   = "tcp",
			       $port    = 1194) {
    $ad_ip                   = $openvpn::vars::ad_ip
    $confdir                 = $openvpn::vars::openvpn_conf_dir
    $dns_ip                  = $openvpn::vars::dns_ip
    $dns_push                = $openvpn::vars::dns_push
    $default_filter          = $openvpn::vars::openvpn_default_filter
    $keepalive               = $openvpn::vars::openvpn_keepalive
    $ldap                    = $openvpn::vars::ldap_slave
    $mute                    = $openvpn::vars::openvpn_mute
    $netmask_map             = $openvpn::vars::netmask_map
    $office_netids           = $openvpn::vars::netids
    $openvpn_ldap_account    = $openvpn::vars::openvpn_ldap_account
    $openvpn_searchuser      = $openvpn::vars::openvpn_searchuser
    $openvpn_ldap_passphrase = $openvpn::vars::openvpn_ldap_passphrase
    $ovpn_push               = $openvpn::vars::openvpn_push_networks
    $push_default_route      = $openvpn::vars::openvpn_push_default
    $script_security         = $openvpn::vars::openvpn_script_security
    $validate_auth           = $openvpn::vars::openvpn_auth_source
    $verbosity               = $openvpn::vars::openvpn_verbosity

    if ($proto == "tcp") {
	$opt = "$ipaddress -p $port -t"
    } else {
	$opt = "$ipaddress -p $port"
    }

    if ($netmsk > 0) {
	$b1 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\1')
	$b2 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\2')
	$b3 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\3')
	$b4 = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\4')

	$increment = $netmsk % 8
	case $increment {
	    7:	{ $finc = 1 }
	    6:	{ $finc = 3 }
	    5:	{ $finc = 7 }
	    4:	{ $finc = 15 }
	    3:	{ $finc = 31 }
	    2:	{ $finc = 63 }
	    1:	{ $finc = 127 }
	    0:  { $finc = 255 }
	}
	if ($netmsk < 8) {
	    $w1 = $b1 + $finc
	    $w2 = "255"
	    $w3 = "255"
	    $w4 = "254"
	} elsif ($netmsk < 16) {
	    $w1 = $b1
	    $w2 = $b2 + $finc
	    $w3 = "255"
	    $w4 = "254"
	} elsif ($netmsk < 24) {
	    $w1 = $b1
	    $w2 = $b2
	    $w3 = $b3 + $finc
	    $w4 = "254"
	} else {
	    $w1 = $b1
	    $w2 = $b2
	    $w3 = $b3
	    $w4 = $b4 + $finc - 1
	}
	$hostmax = "$w1.$w2.$w3.$w4"
	$netroot = regsubst($network, '^(\d+)\.(\d+)\.(\d+)\.(\d+)$', '\1.\2.\3')
    }

    file {
	"OpenVPN $name tunnel configuration":
	    content => template("openvpn/server.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Reload OpenVPN services"],
	    owner   => root,
	    path    => "$confdir/$name.conf",
	    require => File["Prepare OpenVPN for further configuration"];
	"OpenVPN $name connect hook":
	    content => template("openvpn/connect.erb"),
	    group   => $openvpn::vars::runtime_group,
	    mode    => "0750",
	    notify  => Exec["Reload OpenVPN services"],
	    owner   => root,
	    path    => "$confdir/bin/validate-$name.sh",
	    require => File["Prepare OpenVPN bins directory"];
	"OpenVPN $name disconnect hook":
	    content => template("openvpn/disconnect.erb"),
	    group   => $openvpn::vars::runtime_group,
	    mode    => "0750",
	    notify  => Exec["Reload OpenVPN services"],
	    owner   => root,
	    path    => "$confdir/bin/disconnect-$name.sh",
	    require => File["Prepare OpenVPN bins directory"];
    }

    if ($srvtype != "firewall" and $bridge) {
	file {
	    "OpenVPN $name bridge hook":
		content => template("openvpn/bridge.erb"),
		group   => $openvpn::vars::runtime_group,
		mode    => "0750",
		notify  => Exec["Reload OpenVPN services"],
		owner   => root,
		path    => "$confdir/bin/bridge-$name.sh",
		require => File["Prepare OpenVPN bins directory"];
	}
    }

    if (! defined(Network::Interfaces::Generic[$iface])) {
	network::interfaces::generic {
	    $iface:
		ifstate => "down";
	}
    }

    if ($kernel == "Linux") {
	include rsyslog::imfile

	$conf_dir = $openvpn::vars::rsyslog_conf_dir
	$version  = $openvpn::vars::rsyslog_version

	file {
	    "Install iptables NAT configuration":
		content => template("openvpn/iptables_nat.erb"),
		group   => lookup("gid_zero"),
		mode    => "0600",
		notify  => Exec["Reload iptables configuration"],
		owner   => root,
		path    => "/etc/firewall/ruleset.$name",
		require => File["Install iptables application script"];
	    "Install openvpn rsyslog $name configuration":
		content => template("openvpn/rsyslog.erb"),
		group   => lookup("gid_zero"),
		mode    => "0600",
		notify  => Service[$openvpn::vars::rsyslog_service_name],
		owner   => root,
		path    => "$conf_dir/rsyslog.d/08_openvpn_$name.conf",
		require => File["Prepare rsyslog for further configuration"];
	}
    }

    if (! defined(File["OpenVPN $fqdn server certificate"])) {
	pki::define::get {
	    "OpenVPN server certificate":
		ca      => "vpn",
		notify  => Exec["Reload OpenVPN services"],
		require => File["Prepare OpenVPN certificates directory"],
		target  => "$confdir/certificates";
	    "OpenVPN server key":
		ca      => "vpn",
		notify  => Exec["Reload OpenVPN services"],
		require =>
		    [
			File["Prepare OpenVPN keys directory"],
			Pki::Define::Get["OpenVPN server certificate"]
		    ],
		target  => "$confdir/keys",
		what    => "key";
	    "OpenVPN server chain":
		ca      => "vpn",
		notify  => Exec["Reload OpenVPN services"],
		require => Pki::Define::Get["OpenVPN server key"],
		target  => "$confdir/certificates",
		what    => "chain";
	    "OpenVPN server DH":
		notify  => Exec["Reload OpenVPN services"],
		require => Pki::Define::Get["OpenVPN server chain"],
		target  => $confdir,
		what    => "dh";
	}

# dangerously approximative/would need to fix pki::define::wrap
# currently notifying the Service whose name matches pki::define::wrap
# instance title. OpenVPN is driven by an Exec ...
	exec {
	    "Set proper permissions to OpenVPN server key":
		command => "chmod 0640 server.key",
		cwd     => "$confdir/keys",
		notify  => Exec["Reload OpenVPN services"],
		path    => "/usr/bin:/bin",
		require => Pki::Define::Get["OpenVPN server key"],
		unless  => "stat -c 0%a server.key | grep $mode";
	    "Set proper permissions to OpenVPN dh params":
		command => "chmod 0640 dh.pem",
		cwd     => $confdir,
		notify  => Exec["Reload OpenVPN services"],
		path    => "/usr/bin:/bin",
		require => Pki::Define::Get["OpenVPN server DH"],
		unless  => "stat -c 0%a dh.pem | grep $mode";
	}

	File <<| tag == "VPN-CRL" |>>
    }

    nagios::define::probe {
	"openvpn_${name}":
	    command       => "check_openvpn",
	    description   => "$fqdn OpenVPN $name",
	    pluginargs    => [ "$opt" ],
	    pluginconf    => "openvpn",
	    servicegroups => "vpn",
	    use           => "critical-service";
    }

    if ($openvpn::vars::with_collectd) {
	if (! defined(Class[collectd])) {
	    include collectd
	}

	collectd::define::plugin {
	    $name:
		source => "openvpn";
	}
    } else {
	collectd::define::plugin {
	    $name:
		status => "absent";
	}
    }
}
