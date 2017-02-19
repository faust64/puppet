class rsync::service {
    if ($rsync::vars::shares or $rsync::vars::clients) {
	if ($rsync::vars::service_name == "xinetd") {
	    include xinetd
	} else {
	    common::define::service {
		$rsync::vars::service_name:
		    ensure => running;
	    }
	}
    }
}
