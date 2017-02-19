class common {
    stage { "antilope": }
    stage { "chenille": }
    stage { "gazelle": }
    stage { "gnou": }
    stage { "libellule": }

    case $operatingsystem {
	"Debian", "Ubuntu": {
#FIXME: should be included everywhere, not implemented yet
# openbsd to check
# pending rhel env installation
	    if (hiera("ossec_manager") != false) {
		include ossec
	    }
	    include common::debian
	}
	"CentOS", "RedHat": {
	    include common::rhel
	}
	"FreeBSD": {
	    if (hiera("ossec_manager") != false) {
		include ossec
	    }
	    include common::freebsd
	}
	"OpenBSD": {
	    include common::openbsd
	}
	default: {
	    common::define::patchneeded { "common": }
	}
    }

    class {
	common::config::cron:
	    stage => "gazelle";
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	include common::physical::main
    } else {
	include common::virtual
    }
    include common::config::slack
    include common::config::sysctl
    if ($kernel == "Linux") {
	include mysysctl::define::random_va_space
	include mysysctl::define::suid_dumpable
	include common::config::grub
	include common::config::wget
	include logrotate
    }
    if (hiera("with_nagios") == true) {
	include nagios
    }
    if (hiera("with_auditd") == true) {
	include auditd
    }
    if (hiera("with_aide") == true) {
	include aide
    }

    include common::define::schedules
    include common::config::dns
    include common::config::filetraq
    include common::config::fstab
    include common::config::mail
    include common::config::mlocate
    include common::config::motd
    include common::config::ntp
    include common::config::pam
    include common::config::passwd
    include common::config::tcpwrappers
    include common::config::timezone
    include common::fs::perms
    include common::ips
#   include locales
    include network
    if ($hostname != "puppet") {
	include puppet
    }

    if (hiera("do_pakiti")) {
	include pakiti
    }
    if (hiera("do_rkhunter")) {
	include rkhunter
    }
    if (hiera("do_patchdashboard")) {
	include patchdashboard::register
    }
    if (hiera("do_racktables")) {
	include racktables::register
    }
    include rsync
    include shell
    include ssh
    include syslog
    include pki
    include vim

    Stage["libellule"]
	-> Stage["antilope"]
	-> Stage["chenille"]
	-> Stage["gazelle"]
	-> Stage["main"]
	-> Stage["gnou"]
}
