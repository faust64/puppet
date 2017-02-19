class shell {
    include shell::vars

    if ($kernel == "OpenBSD") {
	$whichshell = "ksh"
	include shell::ksh
    } elsif ($kernel == "NetBSD" or $kernel == "FreeBSD") {
	$whichshell = "csh"
	include shell::csh
    } elsif ($kernel == "Linux") {
	$whichshell = "bash"
	include shell::bash
    }
    $whichconf = ".${whichshell}rc"

    include shell::profile
    include shell::scripts
}
