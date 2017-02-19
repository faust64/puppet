class unbound::dnssec {
    $conf_dir = $unbound::vars::conf_dir
    $download = $unbound::vars::download

    exec {
	"Install dlv.isc.org key":
	    command     => "$download http://ftp.isc.org/www/dlv/dlv.isc.org.key",
	    creates     => "$conf_dir/dlv.isc.org.key",
	    cwd         => $conf_dir,
	    notify      => Service["unbound"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare unbound for further configuration"];
    }
}
