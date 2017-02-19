class ftpproxy {
    include ftpproxy::vars

    case $operatingsystem {
	"OpenBSD": {
	    include ftpproxy::openbsd
	}
    }
}
