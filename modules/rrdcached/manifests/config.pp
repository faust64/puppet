class rrdcached::config {
    if ($rrdcached::vars::journalpath != false) {
	if ($rrdcached::vars::sockgroup != false) {
	    $sockgroup = $rrdcached::vars::sockgroup
	} else { $sockgroup = lookup("gid_zero") }
	if ($rrdcached::vars::journalowner != false) {
	    $jrnuser = $rrdcached::vars::journalowner
	} else { $jrnuser = "root" }
	file {
	    "Prepare rrdcached journal directory":
		ensure  => directory,
		group   => $sockgroup,
		mode    => "0755",
		owner   => $jrnuser,
		path    => $rrdcached::vars::journalpath;
	}
    }
}
