class collectd {
    include collectd::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include collectd::debian
	}
	"CentOS", "RedHat": {
	    include collectd::rhel
	}
	"FreeBSD": {
	    include collectd::freebsd
	}
	"OpenBSD": {
	    include collectd::openbsd
	}
	default: {
	    common::define::patchneeded { "collectd": }
	}
    }

    include collectd::config
    include collectd::plugins
    include collectd::service

    if ($kernel == "Linux") {
	include collectd::logrotate
    }
}
