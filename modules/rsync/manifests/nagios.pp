class rsync::nagios {
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"rsync":
	    description   => "$fqdn rsync",
	    require       => Class["common::tools::netstat"],
	    servicegroups => "netservices",
	    use           => "jobs-service";
    }
}
