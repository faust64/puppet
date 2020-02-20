class nsd::filetraq {
    $conf_dir  = $nsd::vars::conf_dir
    $zones_dir = $nsd::vars::zones_dir

    filetraq::define::trac {
	"nsd":
	     pathlist =>
		[
		    "$conf_dir/nsd.conf",
		    "$conf_dir/nsd.conf.d/*.conf",
		    "$zones_dir/db.*"
		];
    }
}
