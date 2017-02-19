class fail2ban {
    include fail2ban::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include fail2ban::rhel
	}
	"Debian", "Ubuntu": {
	    include fail2ban::debian
	}
	"FreeBSD": {
	    include fail2ban::freebsd
	}
	"OpenBSD": {
	    include fail2ban::openbsd
	}
	default: {
	    common::define::patchneeded { "fail2ban": }
	}
    }

    include fail2ban::config
    include fail2ban::filetraq
    include fail2ban::filters
    include fail2ban::munin
    include fail2ban::rsyslog
    include fail2ban::scripts
    include fail2ban::service

    if ($kernel == "Linux") {
	include fail2ban::logrotate
    }
}
