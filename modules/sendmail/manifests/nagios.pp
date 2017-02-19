class sendmail::nagios {
    nagios::define::probe {
	"sendmail":
	    description   => "$fqdn sendmail",
	    servicegroups => "netservices",
	    use           => "jobs-service";
    }
}
