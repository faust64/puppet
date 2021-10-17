define katello::define::policy($ensure     = "present",
			       $hostgroups = false,
			       $hostgroup  = false,
			       $loc        = $katello::vars::katello_loc,
			       $org        = $katello::vars::katello_org,
			       $period     = "weekly",
			       $policy     = $name,
			       $profile    = "xccdf_org.ssgproject.content_profile_standard",
			       $tfile      = false,
			       $tprofile   = false,
			       $when       = "sunday") {
    if ($ensure == "present") {
	if ($tfile) {
	    if ($tprofile) {
		$lookuptailioring = "\$(hammer tailoring-file info --name '$tfile' | grep -B1 '$tprofile' | awk '/Id:/{print \$2;exit;}')"
		$topts            = " --tailoring-file $tfile --tailoring-file-profile-id $lookuptailoring"
	    } else { $topts = " --tailoring-file $tfile" }
	} else { $topts = "" }
	if ($hostgroups) {
	    $hg = $hostgroups.join(',')
	    $hgroups = " --hostgroups $hg"

	    each($hostgroups) |$thegroup| {
		if (defined(Katello::Define::Hostgroup[$thegroup])) {
		    Katello::Define::Hostgroup[$thegroup]
			-> Exec["Install Policy $name"]
		}
	    }
	} elsif ($hostgroup) {
	    $hgroups = " --hostgroups $hostgroup"

	    if (defined(Katello::Define::Hostgroup[$hostgroup])) {
		Katello::Define::Hostgroup[$hostgroup]
		    -> Exec["Install Policy $name"]
	    }
	} else { $hgroups = "" }
	if ($period == "weekly") {
	    $popts = " --weekday '$when'"
	} elsif ($period == "custom") {
	    $popts = " --cron-line '$when'"
	} else { $popts = " --day-of-month '$when'" }

	$lookupprofile = "\$(hammer scap-content info --title '$policy' | grep -B1 '$profile' | awk '/Id:/{print \$2;exit;}')"
	$cmdargs       =
	    [
		"hammer policy create --name '$name' --period '$period'",
		"--scap-content '$policy'$topts --organization '$org'",
		"--location '$loc' --deploy-by manual$popts$hgroups",
		"--scap-content-profile-id $lookupprofile"
	    ]

	exec {
	    "Install Policy $name":
		command     => $cmdargs.join(' '),
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer policy list",
		path        => "/usr/bin:/bin",
		require     =>
		    [
			Exec["Import OpenSCAP Contents"],
			File["Install hammer cli configuration"]
		    ],
		unless      => "hammer policy info --name '$name'";
	}

	if (defined(Katello::Define::Scapcontent[$policy])) {
	    Katello::Define::Scapcontent[$policy]
		-> Exec["Install Policy $name"]
	}
    } else {
	exec {
	    "Drop Policy $name":
		command     => "hammer policy delete --name '$name'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer policy info --name '$name'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
