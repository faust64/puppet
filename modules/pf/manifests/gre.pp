class pf::gre {
    $gre_tunnels = $pf::vars::gre_tunnels
    $skip_gre    = $pf::vars::skip_gre

    file {
	"Pf GRE configuration":
	    content => template("pf/gre.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/GRE",
	    require => File["Pf Configuration directory"];
    }
}
