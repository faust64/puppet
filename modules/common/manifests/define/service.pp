define common::define::service($enable     = true,
			       $ensure     = "running",
			       $hasrestart = true,
			       $hasstatus  = true,
			       $namehack   = $name,
			       $pattern    = false,
			       $statuscmd  = false) {
    if ($kernel == "Linux") {
	service {
	    $namehack:
		enable     => $enable,
		ensure     => $ensure,
		hasrestart => $hasrestart,
		hasstatus  => $hasstatus,
		pattern    => $pattern,
		status     => $statuscmd;
	}
    } else {
	if ($kernel =="OpenBSD") {
	    $arrayvers = split($kernelversion, '\.')
	    $major     = $arrayvers[0]

	    if ($major == "4") {
		File["Make sure we have a minimal RC set"]
		    -> Service[$namehack]
	    }
	}

	service {
	    $namehack:
		ensure     => $ensure,
		hasrestart => $hasrestart,
		hasstatus  => $hasstatus,
		pattern    => $pattern,
		status     => $statuscmd;
	}
    }
}
