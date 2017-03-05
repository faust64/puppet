class apache {
    include apache::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include apache::debian

	    Class[Apache::Debian]
		-> Class[Apache::Config]
	    Class[Apache::Debian]
		-> Class[Apache::Custom]
	}
	"CentOS", "RedHat": {
	    include apache::rhel

	    Class[Apache::Rhel]
		-> Class[Apache::Config]
	    Class[Apache::Rhel]
		-> Class[Apache::Custom]
	}
	"FreeBSD": {
	    include apache::freebsd

	    Class[Apache::Freebsd]
		-> Class[Apache::Config]
	    Class[Apache::Freebsd]
		-> Class[Apache::Custom]
	}
	default: {
	    common::define::patchneeded { "apache": }
	}
    }

    if ($apache::vars::listen_ports['ssl']) {
	include apache::ssl
    }
    if ($apache::vars::mod_security == true) {
	include apache::modsecurity
    }

    include apache::collectd
    include apache::config
    include apache::custom
    include apache::filetraq
    include apache::munin
    include apache::moduledependencies
    include apache::modules
    include apache::mpm
    include apache::nagios
    include apache::service

    if ($kernel == "Linux") {
	include apache::logrotate
    }
    if ($apache::vars::apache_rsyslog == true) {
	include apache::rsyslog
    }
}
