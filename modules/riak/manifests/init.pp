class riak {
    include riak::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include riak::debian
	}
	default: {
	    common::define::patchneeded { "riak": }
	}
    }

    include riak::config
    include riak::collectd
    include riak::munin
    include riak::nagios
    include riak::security
    include riak::scripts
    include riak::service

    if ($riak::vars::riak_ssl) {
	include riak::ssl

	if ($riak::vars::ciphers) {
	    riak::define::ciphers {
		"riak":
		    ciphers => $riak::vars::ciphers;
	    }
	}
    }
    if ($riak::vars::register) {
	include riak::register
    } elsif ($riak::vars::define_buckets != false) {
	create_resources(riak::define::bucket_type, $riak::vars::define_buckets)
    }
    if ($kernel == "Linux") {
	include riak::rsyslog
    }
}
