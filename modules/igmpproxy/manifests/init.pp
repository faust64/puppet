class igmpproxy {
    include igmpproxy::vars

    case $operatingsystem {
	"OpenBSD": {
	    include igmpproxy::openbsd
	}
    }

    include igmpproxy::config
}
