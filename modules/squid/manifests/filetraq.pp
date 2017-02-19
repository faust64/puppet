class squid::filetraq {
    $conf_dir = $squid::vars::conf_dir

    filetraq::define::trac {
	"squid":
	     pathlist => [ "$conf_dir/*.conf", "$conf_dir/*.acl" ];
    }
}
