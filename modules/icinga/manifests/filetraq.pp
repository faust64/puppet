class icinga::filetraq {
    $conf_dir = $icinga::vars::conf_dir

    filetraq::define::trac {
	"icinga":
	     pathlist =>
		[
		    "$conf_dir/objects/*/*",
		    "$conf_dir/objects/*",
		    "$conf_dir/commands.cfg",
		    "$conf_dir/icinga.cfg",
		    "$conf_dir/resource.cfg"
		];
    }
}
