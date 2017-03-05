class memcache {
    include memcache::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include memcache::rhel
	    include memcache::configrh
	}
	"Debian", "Devuan", "Ubuntu": {
	    include memcache::debian
	    include memcache::configdeb
	}
	default: {
	    common::define::patchneeded { "memcache": }
	}
    }

    include memcache::munin
    include memcache::nagios
    include memcache::service
}
