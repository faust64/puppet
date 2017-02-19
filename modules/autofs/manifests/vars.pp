class autofs::vars {
    $conf_dir = hiera("autofs_conf_dir")

    if ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	if ($operatingsystemrelease =~ /6\./) {
	    $no_dir = true
	} else { $no_dir = false }
    } elsif ($operatingsystem == "Debian") {
	if ($lsbdistcodename == "squeeze" or $lsbdistcodename == "lenny") {
	    $no_dir = true
	} else { $no_dir = false }
    } else { $no_dir = false }
}
