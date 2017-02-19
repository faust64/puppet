class apache::status {
    apache::define::vhost {
	"localhost":
	    vhostrsyslog => false,
	    vhostsource => "status";
    }
}
