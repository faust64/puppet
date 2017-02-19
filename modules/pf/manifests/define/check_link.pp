define pf::define::check_link($local = "127.0.0.1") {
    $remote = "8.8.8.8"	# fair chance it will respond to ICMP...

    nagios::define::probe {
	"link_$name":
	    command       => "check_link_$name",
	    description   => "$fqdn $name link status",
	    pluginargs    =>
		[
		    "-s $local",
		    "-d $remote"
		],
	    pluginconf    => "link",
	    servicegroups => "network",
	    use           => "critical-service";
    }
}
