class openldap::filetraq {
    $conf_dir = $openldap::vars::conf_dir

    filetraq::define::trac {
	"openldap":
	     pathlist => [ "$conf_dir/slapd.conf" ];
    }
}
