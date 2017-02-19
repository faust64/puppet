class mongodb::filetraq {
    $conf_dir = $mongodb::vars::conf_dir

    filetraq::define::trac {
	"mongodb":
	     pathlist => [ "$conf_dir/mongodb.conf" ];
    }
}
