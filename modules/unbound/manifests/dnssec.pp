class unbound::dnssec {
    $conf_dir = $unbound::vars::conf_dir

    common::define::geturl {
	"dlv.isc.org key":
	    nomv    => true,
	    notify  => Service["unbound"],
	    require => File["Prepare unbound for further configuration"],
	    target  => "$conf_dir/dlv.isc.org.key",
	    url     => "http://ftp.isc.org/www/dlv/dlv.isc.org.key",
	    wd      => $conf_dir;
    }
}
