define common::define::lined($line   = false,
			     $ensure = "present",
			     $match  = $line,
			     $path   = false) {
    if ($line and $path) {
	if (($kernel == "FreeBSD" and versioncmp($puppetversion, '0.26') <= 0)
	or ($kernel == "Linux" and versioncmp($puppetversion, '2.6') <= 0)) {
	    exec {
		$name:
		    command => "echo '$line' >>$path",
		    cwd     => "/",
		    path    => "/usr/bin:/bin",
		    unless  => "grep '$match' $path";
		"Update $name":
		    command => "( grep -v '$match' $path ; echo '$line' ) >replace && mv replace $path",
		    cwd     => "/tmp",
		    path    => "/usr/bin:/bin",
		    require => Exec[$name],
		    unless  => "grep '$line' $path";
	    }
	} elsif ($match != $line) {
	    file_line {
		$name:
		    ensure => $ensure,
		    line   => $line,
		    match  => $match,
		    path   => $path;
	    }
	} else {
	    file_line {
		$name:
		    ensure => $ensure,
		    line   => $line,
		    path   => $path;
	    }
	}
    }
}
