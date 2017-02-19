class openvpn::jobs {
    cron {
	"Reload OpenVPN instances":
	    command => "/usr/local/sbin/openvpn_resync >/dev/null 2>&1",
	    hour    => "7-22",
	    minute  => "*/15",
	    require => File["OpenVPN application script"],
	    user    => root;
    }
}
