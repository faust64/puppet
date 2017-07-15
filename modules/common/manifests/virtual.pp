class common::virtual {
    if ($kernel == "Linux" and $virtual != "xenu") {
	exec {
	    "Disable root password":
		command => "passwd -l root",
		cwd     => "/etc",
		unless  => "grep '^root:!' shadow",
		path    => "/usr/bin:/bin";
	}
    } elsif ($kernel == "FreeBSD") {
	exec {
	    "Disable root password":
		command => "pw lock root",
		cwd     => "/etc",
		unless  => "grep '^root:*LOCKED*' master.passwd",
		path    => "/usr/sbin:/usr/bin:/bin";
	}
    }
    if (lookup("vps_with_munin") == true) {
	include muninnode
    }
}
