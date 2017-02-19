class nagios::filetraq {
    $conf_dir = $nagios::vars::nagios_conf_dir

    filetraq::define::trac {
	"nagios":
	     pathlist =>
		[
		    "$conf_dir/nrpe.cfg",
		    "$conf_dir/nrpe.d/*"
		];
    }
}
