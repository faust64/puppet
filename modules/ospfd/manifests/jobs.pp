class ospfd::jobs {
    cron {
	"Reload OSPFD configuration":
	    command => "/usr/local/sbin/ospf_resync >/dev/null 2>&1",
	    ensure  => absent,
#	    hour    => "7-22",
#	    minute  => [ "5", "20", "35", "50" ],
	    require => File["Ospf application script"],
	    user    => root;
    }
}
