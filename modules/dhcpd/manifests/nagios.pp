class dhcpd::nagios {
    $plugindir = lookup("nagios_plugins_dir")

    nagios::define::probe {
	"dhcp":
	    command       => "check_procs",
	    description   => "$fqdn DHCP server",
	    pluginargs    =>
		[
		    '-C', 'dhcpd', '-a',
		    'dhcpd.conf'
		],
	    servicegroups => "netservices";
    }
}
