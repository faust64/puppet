class cups::filetraq {
    $conf_dir = $cups::vars::conf_dir

    filetraq::define::trac {
	"cups":
	     pathlist => [ "$conf_dir/*.conf" ];
    }
}
