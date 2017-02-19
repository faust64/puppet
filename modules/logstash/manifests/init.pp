class logstash {
    if (! defined(Class[java])) {
	include java
    }
    if (! defined(Class[curl])) {
	include curl
    }
    include logstash::vars
    include logstash::geoip

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include logstash::debian
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
