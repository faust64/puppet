class tftpproxy {
    case $operatingsystem {
	"OpenBSD": {
	    include tftpproxy::openbsd
	}
    }
}
