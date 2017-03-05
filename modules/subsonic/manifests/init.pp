class subsonic {
    include java
    include subsonic::vars

    if ($subsonic::vars::do_flac == true) {
	include common::tools::flac
    }
    include common::tools::ffmpeg
    include common::tools::lame

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include subsonic::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include subsonic::debian
	}
	default: {
	    common::define::patchneeded { "subsonic": }
	}
    }

    include subsonic::config
#   include subsonic::default
    include subsonic::nagios
    include subsonic::rsyslog
    include subsonic::scripts
    include subsonic::service
    include subsonic::webapp

    if ($subsonic::vars::sync_directories == false) {
	include subsonic::register
    } else {
	include subsonic::collect
	include subsonic::jobs
	include subsonic::masterscripts
    }
}
