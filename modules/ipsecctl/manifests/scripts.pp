class ipsecctl::scripts {
    $alerts  = $ipsecctl::vars::alerts
    $backend = $ipsecctl::vars::ipsecctl_default_backend

    file {
	"Ipsecctl tunnel reload script":
	    content => template("ipsecctl/reload.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/reload_tunnels";
	"Ipsecctl application script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/ipsec_resync",
	    source  => "puppet:///modules/ipsecctl/resync";
    }
}
