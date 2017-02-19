class freeradius::service {
    $srvname = $freeradius::vars::service_name
    $match   = "[/]$srvname"

    common::define::service {
	$srvname:
	    ensure    => running,
	    hasstatus => false,
	    statuscmd => "ps ax | grep '$match'";
    }
}
