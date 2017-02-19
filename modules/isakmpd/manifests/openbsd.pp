class isakmpd::openbsd {
    $args = $isakmpd::vars::args

    file_line {
	"Enable isakmpd on boot":
	    line  => "isakmpd_flags='$args'",
#	    match => 'isakmpd_flags=',
	    path  => "/etc/rc.conf.local";
    }

    File_line["Enable isakmpd on boot"]
	-> File["Install Isakmpd main configuration"]
#	-> Service["isakmpd"]
}
