class sudo::filetraq {
    $conf_dir = $sudo::vars::conf_dir

    filetraq::define::trac {
	"sudo":
	     pathlist =>
		[
		    "$conf_dir/sudoers",
		    "$conf_dir/sudoers.d/*"
		];
    }
}
