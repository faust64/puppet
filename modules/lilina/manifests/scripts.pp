class lilina::scripts {
    file {
	"Install lilina update script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/update_lilina_subscriptions",
	    source  => "puppet:///modules/lilina/update";
    }
}
