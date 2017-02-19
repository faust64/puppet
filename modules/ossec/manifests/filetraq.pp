class ossec::filetraq {
    $conf_dir = $ossec::vars::conf_dir

    filetraq::define::trac {
	"ossec": pathlist => [ "$conf_dir/etc/ossec.conf" ];
    }
}
