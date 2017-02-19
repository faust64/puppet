class pixelserver::webapp {
    include nginx

    nginx::define::vhost {
	"_":
	    app_port     => "9999",
	    require      => Service["pixelserver"],
	    vhostrsyslog => false,
	    vhostsource  => "app_proxy";
    }
}
