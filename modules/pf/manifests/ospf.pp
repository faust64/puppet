class pf::ospf {
    $ipsec_offices = false
    $linkvaldb     = $pf::vars::linkvaldb
    $office_id     = $pf::vars::netids
    $ospf_database = $pf::vars::ospf_database
    $ospf_map      = $pf::vars::ospf_map

    file {
	"Pf OSPF Configuration":
	    content => template("pf/ospf.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/OSPF",
	    require => File["Pf Configuration directory"];
    }
}
