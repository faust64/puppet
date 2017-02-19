class rkhunter::filetraq {
    $conf_dir = $rkhunter::vars::conf_dir

    filetraq::define::trac {
	"rkhunter":
	     pathlist => [ "$conf_dir/rkhunter.conf" ];
    }
}
