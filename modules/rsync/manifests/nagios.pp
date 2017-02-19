class rsync::nagios {
    nagios::define::probe {
	"rsync":
	    description   => "$fqdn rsync",
	    servicegroups => "netservices",
	    use           => "jobs-service";
    }
}
