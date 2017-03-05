class aptcacherng {
    include aptcacherng::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include aptcacherng::debian
	}
	default: {
	    common::define::patchneeded { "apt-cacher-ng": }
	}
    }

    include aptcacherng::config
    include aptcacherng::service

    if ($kernel == "Linux") {
	include aptcacherng::logrotate
    }

    include aptcacherng::nagios
}
