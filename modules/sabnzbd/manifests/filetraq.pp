class sabnzbd::filetraq {
    $conf_dir = $sabnzbd::vars::conf_dir

    filetraq::define::trac {
	"sabnzbd":
	     pathlist => [ "$conf_dir/config.ini" ];
    }
}
