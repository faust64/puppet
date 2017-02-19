class apache::filetraq {
    $conf_dir  = $apache::vars::conf_dir
    $conf_file = $apache::vars::conf_file

    filetraq::define::trac {
	"apache":
	     pathlist =>
		[
		    "$conf_dir/mods-enabled/*",
		    "$conf_dir/sites-enabled/*",
		    "$conf_dir/$conf_file",
		    "$conf_dir/ports.conf"
		];
    }
}
