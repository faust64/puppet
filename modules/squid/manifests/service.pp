class squid::service {
    if ($squid::vars::wat_do == "cache" or $squid::vars::wat_do == "filter") {
	$cmd = $squid::vars::squid_command

	exec {
	    "Initialize Squid cache directory":
		command => "$cmd -z",
		cwd     => $squid::vars::cache_dir,
		notify  => Service[$squid::vars::service_name],
		path    => "/usr/local/sbin:/usr/sbin:/usr/bin:/sbin:/bin",
		unless  => "test -d 00",
		require =>
		    [
			File["Install Squid main configuration"],
			File["Prepare Squid cache directory"]
		    ];
	}

	Exec["Initialize Squid cache directory"]
	    -> Common::Define::Service[$squid::vars::service_name]
    }

    common::define::service {
	$squid::vars::service_name:
	    ensure  => running,
	    require =>
		[
		    File["Install Squid main configuration"],
		    File["Prepare Squid log directory"]
		];
    }
}
