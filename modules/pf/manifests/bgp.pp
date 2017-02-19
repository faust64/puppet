class pf::bgp {
    $bgp_database = $pf::vars::bgp_database
    $bgp_map      = $pf::vars::bgp_map

    file {
	"Pf BGP Configuration":
	    content => template("pf/bgp.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/BGP",
	    require => File["Pf Configuration directory"];
    }
}
