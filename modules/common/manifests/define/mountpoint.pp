define common::define::mountpoint($dev        = false,
				  $dump       = 0,
				  $fmt        = false,
				  $genericdev = false,
				  $mount      = false,
				  $opts       = "defaults",
				  $pass       = 0,
				  $remount    = false) {
    if ($dev and $fmt and $mount) {
	$line = "$dev $mount $fmt $opts $dump $pass"

	if ($genericdev) {
	    $match = "^$dev[ \t]$mount[ \t]"
	} else {
	    $match = "^$dev[ \t]"
	}

	common::define::lined {
	    "Define $name mountpoint":
		line  => $line,
		match => $match,
		path  => "/etc/fstab";
	}

	if ($remount) {
	    exec {
		"Remount $name directory":
		    command   => "mount $dir -o remount,$opts",
		    cwd       => "/",
		    path      => "/usr/bin:/bin",
		    subscribe => File_line["Define $name mountpoint"];
	    }
	}
    } else {
	notify { "Can't define $name mountpoint: arguments missing": }
    }
}
