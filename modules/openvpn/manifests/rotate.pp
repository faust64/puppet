class openvpn::rotate {
    cron {
	"Rotate OpenVPN logs":
	    command => "/usr/local/sbin/openvpn_resync -R >/dev/null 2>&1",
	    hour    => 5,
	    minute  => 42,
	    require => File["OpenVPN application script"],
	    user    => root,
	    weekday => 6;
    }
}
