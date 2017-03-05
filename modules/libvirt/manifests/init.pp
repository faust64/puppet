class libvirt {
    include libvirt::vars
    include python

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include libvirt::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include libvirt::debian
	}
	"FreeBSD": {
	    include libvirt::freebsd
	}
	default: {
	    common::define::patchneeded { "libvirt": }
	}
    }

    include libvirt::config
    include libvirt::filetraq
    include libvirt::nagios
    include libvirt::profile
    include libvirt::scripts

    if ($kernel == "Linux") {
	include libvirt::logrotate
    }
}
