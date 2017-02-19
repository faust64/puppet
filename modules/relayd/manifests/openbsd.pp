class relayd::openbsd {
    file_line {
	"Enable relayd on boot":
	    line => "relayd_flags=",
	    path => "/etc/rc.conf.local";
    }

    File["Relayd main configuration"]
	-> File_line["Enable relayd on boot"]
	-> Service["relayd"]
}
