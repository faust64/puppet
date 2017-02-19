class icecast::service {
    common::define::service {
	$icecast::vars::service_name:
	    ensure    => running,
	    hasstatus => false,
	    statuscmd => 'bin/icecast2 ';
    }
}
