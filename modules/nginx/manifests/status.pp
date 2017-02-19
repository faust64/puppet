class nginx::status {
    nginx::define::vhost {
	"localhost":
	    vhostrsyslog => false,
	    vhostsource  => "status";
    }
}
