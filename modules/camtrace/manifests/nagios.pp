class camtrace::nagios {
    nagiod::define::probe {
	"scamd":
	    description   => "$fqdn scamd server",
	    servicegroups => "videosurveillance",
	    use           => "critical-service";
    }
}
