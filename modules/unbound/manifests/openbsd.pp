class unbound::openbsd {
    file_line {
	"Enable unbound on boot":
	    line => "unbound_flags=",
	    path => "/etc/rc.conf.local";
    }

    File_line["Enable unbound on boot"]
	-> Service["unbound"]
}
