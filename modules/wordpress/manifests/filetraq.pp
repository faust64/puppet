class wordpress::filetraq {
    $conf_dir = $wordpress::vars::conf_dir

    filetraq::define::trac {
	"wordpress":
	     pathlist => [ "$conf_dir/config*php" ];
    }
}
