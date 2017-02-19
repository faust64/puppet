class wifimgr::service {
    common::define::service {
	"unifi":
	    ensure => running;
    }

    if ($wifimgr::vars::aironet_host) {
	cron {
	    "Renew Guest WiFi PSK":
		command => "/usr/local/sbin/aironet_renew_guest_psk >/dev/null 2>&1",
		hour    => 8,
		minute  => 0,
		require => File["Install Aironet Guest access passphrase update script"],
		user    => root;
	    "Purge WiFi MAC ACLs":
		command => "/usr/local/sbin/aironet_flush_hwfilter >/dev/null 2>&1",
		hour    => 22,
		minute  => 0,
		require => File["Install Aironet MAC filtering reset script"],
		user    => root;
	}
    }
}
