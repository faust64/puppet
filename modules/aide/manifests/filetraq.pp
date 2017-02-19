class aide::filetraq {
    $conf_dir = $aide::vars::conf_dir

    filetraq::define::trac {
	"aide":
	     pathlist => [ "$conf_dir/*", "$conf_dir/*/*" ];
    }
}
