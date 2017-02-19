define nagios::define::check_certificates() {
    nagios::define::probe {
	"certificates":
	    description   => "$fqdn certificates",
	    servicegroups => "certificates",
	    use           => "jobs-service";
    }
}
