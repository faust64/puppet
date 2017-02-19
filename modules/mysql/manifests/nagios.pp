class mysql::nagios {
    nagios::define::probe {
	"mysql":
	    description   => "$fqdn mysql server",
	    pluginargs    =>
		[
		    "-u $msuser",
		    "-p '$mspw'"
		],
	    servicegroups => "databases",
	    use           => "critical-service";
    }
}
