class ipsecctl::openbsd {
    $ipsec_tunnels            = $ipsecctl::vars::ipsec_tunnels
    $ipsecctl_default_backend = $ipsecctl::vars::ipsecctl_default_backend

    common::define::package {
	"ike-scan":
    }

    if ($ipsecctl_default_backend == "isakmpd") {
	include isakmpd
#   } elsif $ipsecctl_default_backend == "iked") {
#	include iked
    } else {
	notify { "Invalid ipsecctl backend '$ipsecctl_default_backend'": }
    }

    file {
	"Install Ipsecctl main configuration":
	    content => template("ipsecctl/ipsec.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload ipsec configuration"],
	    owner   => root,
	    path    => "/etc/ipsec.conf",
	    require => File["Prepare Ipsecctl for further configuration"];
    }

    exec {
	"Reload ipsec configuration":
	    command     => "ipsec_resync",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Ipsecctl application script"];
    }
}
