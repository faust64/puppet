class openvpn::scripts {
    require openldap::client

    $alerts = $openvpn::vars::alerts
    $rotate = $openvpn::vars::rotate

    if (! defined(Package[lsof])) {
	common::define::package {
	    "lsof":
	}
    }

    file {
	"OpenVPN application script":
	    content => template("openvpn/resync.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/openvpn_resync";
	"OpenVPN connection validation script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/openvpn_connect.sh",
	    source  => "puppet:///modules/openvpn/connect.sh";
	"OpenVPN deconnection validation script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/openvpn_disconnect.sh",
	    source  => "puppet:///modules/openvpn/disconnect.sh";
	"OpenVPN WhoisThere script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/openvpn_whoisthere",
	    source  => "puppet:///modules/openvpn/whoisthere";
    }
}
