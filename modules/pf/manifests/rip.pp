class pf::rip {
    $rip_map = $pf::vars::rip_map

    file {
	"Pf RIP Configuration":
	    content => template("pf/rip.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/RIP",
	    require => File["Pf Configuration directory"];
    }
}
