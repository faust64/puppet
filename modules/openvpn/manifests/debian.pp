class openvpn::debian {
    common::define::package {
	"openvpn":
    }

    if ($openvpn::vars::openvpn_auth_source == "ldap") {
	common::define::package {
	    "openvpn-auth-ldap":
	}

	Package["openvpn-auth-ldap"]
	    -> Package["openvpn"]
    }

    file {
	"Install OpenVPN service defaults":
	    group  => hiera("gid_zero"),
	    mode   => "0644",
	    owner  => root,
	    path   => "/etc/default/openvpn",
	    source => "puppet:///modules/openvpn/default";
	"Drop OpenVPN logrotate configuration":
	    ensure => absent,
	    force  => true,
	    path   => "/etc/logrotate.d/openvpn";
    }

    Common::Define::Package["openvpn"]
	-> File["Drop OpenVPN logrotate configuration"]
	-> File["Install OpenVPN service defaults"]
	-> Group["OpenVPN runtime group"]
}
