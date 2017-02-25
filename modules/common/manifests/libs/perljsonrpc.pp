class common::libs::perljsonrpc {
    case $operatingsystem {
	"Debian", "Ubuntu": {
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
