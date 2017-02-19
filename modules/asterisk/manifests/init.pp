class asterisk {
    include asterisk::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include asterisk::rhel
	}
	"Debian", "Ubuntu": {
	    include asterisk::debian
	}
	default: {
	    common::define::patchneeded { "asterisk": }
	}
    }

    include asterisk::agi
    include asterisk::bacula
    include asterisk::configd
    include asterisk::config
    include asterisk::contextes
    include asterisk::extensions
    include asterisk::iax
    include asterisk::jobs
    include asterisk::manager
    include asterisk::misc
    include asterisk::munin
    include asterisk::nagios
    include asterisk::phonemisc
    include asterisk::phoneprov
    include asterisk::queues
    include asterisk::scripts
    include asterisk::service
    include asterisk::sip
    include asterisk::sounds
    include asterisk::voicemail
    include asterisk::webapp

    if ($asterisk::vars::iax_trunks != false) {
	include asterisk::codecs
    }
    if ($asterisk::vars::dahdi_chans and $virtual == "physical") {
	include asterisk::dahdi
    }
    if ($kernel == "Linux") {
	include asterisk::logrotate
    }
    if ($asterisk::vars::asterisk_rsyslog == true) {
	include asterisk::rsyslog
    }
}
