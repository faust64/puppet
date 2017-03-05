class common::libs::perljsonrpc {
    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    $what = "libjson-rpc-perl"
	}
	"CentOS", "RedHat": {
	    include common::libs::perljson
	}
    }

    if ($what) {
	common::define::package { $what: }
    }
}
