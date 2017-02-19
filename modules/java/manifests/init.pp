class java {
    include java::vars

    case $operatingsystem {
	"CentOS", "RedHat": {
	    include java::rhel
	}
	"Debian", "Ubuntu": {
	    include java::debian
	}
	default: {
	    common::define::patchneeded { "java": }
	}
    }
}
