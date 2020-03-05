define common::define::geturl($create   = false,
			      $grp      = lookup("gid_zero"),
			      $nocrtchk = false,
			      $nomv     = false,
			      $noperms  = false,
			      $noproxy  = false,
			      $prm      = "0644",
			      $target   = "/tmp/output",
			      $tmout    = 300,
			      $url      = false,
			      $usr      = "root",
			      $wd       = "/root") {
    $download = lookup("download_cmd")

    if ($download == "wget" and defined(Common::Define::Package["wget"])) {
	Common::Define::Package["wget"]
	    -> Exec["Downloads $name"]
    }

    if ($nocrtchk) {
	if ($download == "wget") {
	    $crtargs = " --no-check-certificate"
	} elsif ($download == "curl") {
	    $crtargs = " -k"
	} else {
	    $crtargs = ""
	}
    } else {
	$crtargs = ""
    }
    if ($noproxy) {
	if ($download == "wget") {
	    $prxargs = " --no-proxy"
	} elsif ($download == "curl") {
	    $prxargs = " --noproxy '*'"
	} else {
	    $prxargs = ""
	}
    } else {
	$prxargs = ""
    }
    $rcmd = "$download$crtargs$prxargs"

    if ($create == false) {
	$check_with = $target
    } else {
	$check_with = $create
    }

    if ($nomv) {
	exec {
	    "Downloads $name":
		command     => "$rcmd $url",
		creates     => $check_with,
		cwd         => $wd,
		path        => "/usr/local/bin:/usr/bin:/bin",
		timeout     => $tmout;
	}

	if ($noperms == false) {
	    Exec["Downloads $name"]
		-> File["Sets $name permissions"]
	}
    } else {
	exec {
	    "Downloads $name":
		command     => "$rcmd $url",
		creates     => $check_with,
		cwd         => $wd,
		notify      => Exec["Installs $name"],
		path        => "/usr/local/bin:/usr/bin:/bin",
		timeout     => $tmout;
	    "Installs $name":
		command     => "mv \"$(echo $url | awk -F/ '{print \$NF}')\" \"$target\"",
		creates     => $check_with,
		cwd         => $wd,
		path        => "/usr/local/bin:/usr/bin:/bin",
		refreshonly => true;
	}

	if ($noperms == false) {
	    Exec["Installs $name"]
		-> File["Sets $name permissions"]
	}
    }

    if ($noperms == false) {
	file {
	    "Sets $name permissions":
		ensure  => present,
		group   => $grp,
		mode    => $prm,
		owner   => $usr,
		path    => $target;
	}
    }
}
