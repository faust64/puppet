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
    }

    include ifstated::key
    include ifstated::config
    include ifstated::service
}
