class logstash {
    if (! defined(Class[java])) {
	include java
    }
    if (! defined(Class[curl])) {
	include curl
    }
    include logstash::vars
    include logstash::geoip

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include logstash::debian

	    Class[java]
		-> Class[logstash::debian]
	}
	default: {
	    common::define::patchneeded { "logstash": }
	}
    }

    include logstash::config
    include logstash::nagios
    include logstash::plugins
    include logstash::service
}
