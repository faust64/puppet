class openvpn::filetraq {
    $conf_dir = $openvpn::vars::openvpn_conf_dir

    filetraq::define::trac {
	"openvpn":
	     pathlist => [ "$conf_dir/*.conf" ];
    }
}
