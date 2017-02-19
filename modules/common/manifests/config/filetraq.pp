class common::config::filetraq {
    include ::filetraq

    if ($kernel == "Linux") {
	$list = [ "/etc/passwd", "/etc/group", "/etc/shadow-", "/etc/shadow",
		  "/etc/passwd-", "/etc/group-" ]
    } else {
	$list = [ "/etc/passwd", "/etc/group" ]
    }

    filetraq::define::trac {
	"system-defaults":
	    pathlist => $list;
    }
}
