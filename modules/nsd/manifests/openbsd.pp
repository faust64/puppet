class nsd::openbsd {
    file_line {
	"Enable nsd on boot":
	    line => "nsd_flags=",
	    path => "/etc/rc.conf.local";
    }

    File_line["Enable nsd on boot"]
	-> File["Prepare NSD for further configuration"]
	-> Service["nsd"]
}
