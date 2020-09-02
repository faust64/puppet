class common::config::filetraq {
    include ::filetraq

    if ($kernel == "Linux") {
	$list = [ "/etc/passwd", "/etc/group", "/etc/shadow-", "/etc/shadow",
		  "/etc/passwd-", "/etc/group-" ]

	file {
	    "Ensures rc.local exists":
		content => "",
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/etc/rc.local",
		replace => "no";
	}
    } else {
	$list = [ "/etc/passwd", "/etc/group" ]
    }

    filetraq::define::trac {
	"system-defaults":
	    pathlist => $list;
    }
}
