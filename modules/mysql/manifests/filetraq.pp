class mysql::filetraq {
    $conf_dir = $mysql::vars::conf_dir

    filetraq::define::trac {
	"mysql":
	     pathlist => [ "$conf_dir/my.cnf" ];
    }
}
