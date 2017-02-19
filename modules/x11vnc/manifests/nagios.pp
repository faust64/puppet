class x11vnc::nagios {
    nagios::define::probe {
	"vnc":
	    description   => "$fqdn vnc server",
	    servicegroups => "videosurveillance",
	    use           => "error-service";
    }
}
