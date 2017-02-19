class openvz {
    include openvz::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include openvz::rhel
	}
	"Debian", "Ubuntu": {
	    include openvz::debian
	}
	default: {
	    common::define::patchneeded { "openvz": }
	}
    }

    include openvz::backups
    include openvz::common
    include openvz::config
    include openvz::filetraq
    include openvz::jobs
    include openvz::modeles
    include openvz::munin
    include openvz::nagios
    include openvz::profile
    include openvz::scripts
}
