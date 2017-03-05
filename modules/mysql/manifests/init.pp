class mysql {
    include mysql::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include mysql::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include mysql::debian
	}
	default: {
	    common::define::patchneeded { "mysql": }
	}
    }

    include mysql::config
    include mysql::filetraq
    include mysql::munin
    include mysql::profile
    include mysql::scripts
    include mysql::service

    if ($mysql::vars::keep_backup) {
	include mysql::backups
    }
    if ($msuser != "imacat" and $mspw != "imacat" and $msuser and $mspw ) {
	include mysql::nagios
    }
    if ($mysql::vars::log_slowqueries == true) {
	include mysql::rsyslog
    }
    if ($kernel == "Linux") {
	include mysql::logrotate
    }
}
