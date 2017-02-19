class fail2ban::filetraq {
    $conf_dir = $fail2ban::vars::conf_dir

    filetraq::define::trac {
	"fail2ban":
	     pathlist => [ "$conf_dir/*/*", "$conf_dir/*.conf" ];
    }
}
