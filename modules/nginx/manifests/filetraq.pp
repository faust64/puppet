class nginx::filetraq {
    $conf_dir = $nginx::vars::conf_dir

    filetraq::define::trac {
	"nginx":
	     pathlist =>
		[
		    "$conf_dir/sites-enabled/*",
		    "$conf_dir/nginx.conf"
		];
    }
}
