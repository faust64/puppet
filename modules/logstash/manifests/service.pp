class logstash::service {
    common::define::service {
	"logstash":
	    ensure => running;
    }
}
