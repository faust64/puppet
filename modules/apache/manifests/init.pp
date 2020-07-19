class apache {
    include apache::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include apache::debian

	    Class["apache::debian"]
		-> Class["apache::config"]
	    Class["apache::debian"]
		-> Class["apache::custom"]
	}
	"CentOS", "RedHat": {
	    include apache::rhel

	    Class["apache::rhel"]
		-> Class["apache::config"]
	    Class["apache::rhel"]
		-> Class["apache::custom"]
	}
	"FreeBSD": {
	    include apache::freebsd

	    Class["apache::freebsd"]
		-> Class["apache::config"]
	    Class["apache::freebsd"]
		-> Class["apache::custom"]
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
