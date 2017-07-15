class openvpn::config {
    include mysysctl::define::forwarding

    $base_suffix     = $openvpn::vars::openvpn_base_suffix
    $search_user     = $openvpn::vars::openvpn_searchuser
    $confdir         = $openvpn::vars::openvpn_conf_dir
    $ldap_host       = $openvpn::vars::ldap_slave
    $ldap_passphrase = $openvpn::vars::openvpn_ldap_passphrase
    $validate_auth   = $openvpn::vars::openvpn_auth_source

    group {
	"OpenVPN runtime group":
	    ensure => present,
	    name   => $openvpn::vars::runtime_group;
    }

#    user {
#	"OpenVPN runtime user":
#	    ensure   => present,
#	    groups   => $openvpn::vars::runtime_group,
#	    home     => $openvpn::vars::runtime_homedir,
#	    name     => $openvpn::vars::runtime_user,
#	    require  => Group["OpenVPN runtime group"];
#    }

    file {
	"Prepare OpenVPN for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $confdir,
	    require => Group["OpenVPN runtime group"];
	"Prepare OpenVPN certificates directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$confdir/certificates",
	    require => File["Prepare OpenVPN for further configuration"];
	"Prepare OpenVPN keys directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0710",
	    owner   => root,
	    path    => "$confdir/keys",
	    require => File["Prepare OpenVPN for further configuration"];
	"Prepare OpenVPN bins directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0711",
	    owner   => root,
	    path    => "$confdir/bin",
	    require => File["Prepare OpenVPN for further configuration"];
    }

    if ($validate_auth == "ldap") {
	file {
	    "Prepare OpenVPN auth configuration directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "$confdir/auth",
		require => File["Prepare OpenVPN for further configuration"];
	    "Install OpenVPN auth ldap configuration":
		content => template("openvpn/ldap.erb"),
		group   => lookup("gid_zero"),
		mode    => "0640",
		notify  => Exec["Reload OpenVPN services"],
		owner   => root,
		path    => "$confdir/auth/auth-ldap.conf",
		require => File["Prepare OpenVPN auth configuration directory"];
	}
    }

    if ($kernel == "Linux") {
	file {
	    "Prepare iptables configuration directory":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0710",
		owner   => root,
		path    => "/etc/firewall";
	    "Install iptables application script":
		group   => lookup("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => "/etc/firewall/apply",
		require => File["Prepare iptables configuration directory"],
		source  => "puppet:///modules/openvpn/iptables_apply";
	}
    }
}
