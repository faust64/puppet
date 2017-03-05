class ifstated {
    include ifstated::vars
    include ifstated::scripts

    case $operatingsystem {
	"FreeBSD": {
	    include ifstated::freebsd
	}
	"OpenBSD": {
	    include ifstated::openbsd
	}
	default: {
	    common::define::patchneeded { "ifstated": }
	}
    }

    include ifstated::key
    include ifstated::config
    include ifstated::service
}
