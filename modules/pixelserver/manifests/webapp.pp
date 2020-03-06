class pixelserver::webapp {
    if (defined(Class["apache"])) {
	apache::define::vhost {
	    "*":
		app_port     => "9999",
		require      => Common::Define::Service["pixelserver"],
		vhostrsyslog => false,
		vhostsource  => "app_proxy";
	}
    } elsif ($operatingsystem != "OpenBSD") {
	include nginx

	nginx::define::vhost {
	    "_":
		app_port     => "9999",
		require      => Common::Define::Service["pixelserver"],
		vhostrsyslog => false,
		vhostsource  => "app_proxy";
	}
    }
}
