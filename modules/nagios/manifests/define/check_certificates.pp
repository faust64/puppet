define nagios::define::check_certificates() {
    nagios::define::probe {
	"certificates":
	    description   => "$fqdn certificates",
	    pluginconf    => "certificates",
	    servicegroups => "certificates",
	    use           => "jobs-service";
    }
}
