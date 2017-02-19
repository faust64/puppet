class unbound::filetraq {
    $conf_dir = $unbound::vars::conf_dir

    filetraq::define::trac {
	"unbound":
	     pathlist => [ "$conf_dir/unbound.conf" ];
    }
}
