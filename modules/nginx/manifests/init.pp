class nginx {
    include nginx::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include nginx::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include nginx::debian
	}
	"OpenBSD": {
	    include nginx::openbsd
	}
	default: {
	    common::define::patchneeded { "nginx": }
	}
    }

    if ($nginx::vars::listen_ports['ssl'] != false) {
	include nginx::ssl
    }

    include nginx::collectd
    include nginx::config
    include nginx::custom
    include nginx::filetraq
    include nginx::munin
    include nginx::nagios
    include nginx::service

    if ($kernel == "Linux") {
	include nginx::logrotate
    }
    if ($nginx::vars::nginx_rsyslog == true) {
	include nginx::rsyslog
    }
}
