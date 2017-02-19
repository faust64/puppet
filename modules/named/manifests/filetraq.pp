class named::filetraq {
    $conf_dir = $named::vars::conf_dir

    filetraq::define::trac {
	"named":
	     pathlist =>
		[
		    "$conf_dir/named.*",
		    "$conf_dir/db.*",
		    "$conf_dir/*/db.*"
		];
    }
}
