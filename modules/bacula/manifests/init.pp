class bacula {
    include bacula::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include bacula::rhel
	}
	"Debian", "Ubuntu": {
	    include bacula::debian
	}
	default: {
	    common::define::patchneeded { "bacula": }
	}
    }

    if ($kernel == "Linux") {
	include bacula::logrotate
    }

    if ($bacula::vars::file_daemon_fileset
	or $bacula::vars::director_host == $fqdn) {
	include bacula::client
	include bacula::nagiosfd
    }
    if ($bacula::vars::storage_host == $fqdn) {
	include bacula::storage
	include bacula::nagiossd
    }
    if ($bacula::vars::director_host == $fqdn) {
	include bacula::console
	include bacula::director
	include bacula::nagiosdir
	if ($bacula::vars::do_webapp) {
	    include bacula::webapp
	}
    }

    include bacula::config
    include bacula::service
}
