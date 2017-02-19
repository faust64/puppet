class auditd {
    include auditd::vars

    case $operatingsystem {
	"Debian", "Ubuntu": {
	    include auditd::debian
	}
	"CentOS", "RedHat": {
	    include auditd::rhel
	}
	default: {
	    common::define::patchneeded { "auditd": }
	}
    }

    if ($kernel == "Linux") {
	include auditd::grub
    }

    include auditd::config
    include auditd::plugins
    include auditd::filetraq
    include auditd::service
}
