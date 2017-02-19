class sickbeard::filetraq {
    $conf_dir = $sickbeard::vars::conf_dir

    filetraq::define::trac {
	"sickbeard":
	     pathlist => [ "$conf_dir/config.ini" ];
    }
}
