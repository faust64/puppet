class mysql::nagios {
    if ($mspw != "") {
	$args = [ "-u $msuser", "-p '$mspw'" ]
    } elsif ($msuser != "") {
	$args = [ "-u $msuser" ]
    } else { $args = [] }

    nagios::define::probe {
	"mysql":
	    description   => "$fqdn mysql server",
	    pluginargs    => $args,
	    servicegroups => "databases",
	    use           => "critical-service";
    }
}
