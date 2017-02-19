class postfix::filetraq {
    $conf_dir = $postfix::vars::conf_dir

    filetraq::define::trac {
	"postfix":
	     pathlist => [ "$conf_dir/*" ];
    }
}
