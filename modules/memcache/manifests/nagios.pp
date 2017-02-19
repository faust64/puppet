class memcache::nagios {
    nagios::define::probe {
	"memcached":
	    description   => "$fqdn memcached",
	    pluginargs    => [ "-H", $memcache::vars::listen ],
	    servicegroups => "databases",
	    use           => "critical-service";
    }
}
