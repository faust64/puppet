class java {
    include java::vars

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include java::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include java::debian
	}
	default: {
	    common::define::patchneeded { "java": }
	}
    }
}
