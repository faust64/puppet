class riakcs {
    include riakcs::vars

    if ($riakcs::vars::stanchion == $riakcs::vars::listen
	or ($riakcs::vars::stanchion == false
	and ($riakcs::vars::listen == "127.0.0.1"
	    or $riakcs::vars::riak_master == $riakcs::vars::listen
	    or $riakcs::vars::riak_master == false))) {
	include stanchion
    }
    if (! defined(Class[Riak])) {
	include riak
    }

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include riakcs::debian
	}
	default: {
	    common::define::patchneeded { "riakcs": }
	}
    }

    include riakcs::config
    include riakcs::nagios
    include riakcs::service
}
