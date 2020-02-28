class ipsecctl::jobs {
    cron {
	"Reload IPSEC tunnels":
	    command => "/usr/local/sbin/reload_tunnels >/dev/null 2>&1",
	    hour    => "6-23",
	    minute  => "*/5",
	    require => File["Ipsecctl tunnel reload script"],
	    user    => root;
    }
}
