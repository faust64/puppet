class filetraq::filetraq {
    $conf_dir     = $filetraq::vars::conf_dir
    $conf_include = $filetraq::vars::conf_include

    filetraq::define::trac {
	"filetraq":
	     pathlist =>
		[
		    "$conf_include/*",
		    "$conf_dir/filetraq.conf"
		];
    }
}
