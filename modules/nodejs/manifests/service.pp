class nodejs::service {
    if ($pm2version != "") {
	if (versioncmp($pm2version, '2.5.0') < 0) {
	    $namehack = $nodejs::vars::service_name
	} else {
	    $pm2user  = $nodejs::vars::pm2_user
	    $namehack = "pm2-$pm2user"
	}
    } else {
	$namehack = $nodejs::vars::service_name
    }
    common::define::service {
	$nodejs::vars::service_name:
	    name   => $namehack,
	    ensure => running;
    }
}
