class redis {
    include redis::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include redis::debian
	}
	default: {
	    common::define::patchneeded { "redis": }
	}
    }

    if ($redis::vars::slaveof) {
	include redis::sentinel
    }
    include redis::config
    include redis::munin
    include redis::nagios
    include redis::service
}
