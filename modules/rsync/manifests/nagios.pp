class rsync::nagios {
    if (! defined(Class[Common::Tools::Netstat])) {
	include common::tools::netstat
    }

    nagios::define::probe {
	"rsync":
	    description   => "$fqdn rsync",
	    require       => Class[Common::Tools::Netstat],
	    servicegroups => "netservices",
	    use           => "jobs-service";
    }
}
