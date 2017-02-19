class btsync::service {
    btsync::define::instance {
	$fqdn:
	    shared_folders => $btsync::vars::shared_folders;
    }

    common::define::service {
	"btsync":
	    ensure => running;
    }
}
