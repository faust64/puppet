class rsyslog::filetraq {
    $conf_dir = $rsyslog::vars::conf_dir

    filetraq::define::trac {
	"rsyslog":
	     pathlist => [ "$conf_dir/rsyslog.conf", "$conf_dir/rsyslog.d/*" ];
    }
}
