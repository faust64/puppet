class dhcpd::nagios {
    $plugindir = hiera("nagios_plugins_dir")

    exec {
	"Setuid check_dhcp":
	    command => "chmod u+s check_dhcp",
	    cwd     => $plugindir,
	    path    => "/usr/bin:/bin",
	    unless  => "test `stat -c %a check_dhcp` = 4755";
    }

    nagios::define::probe {
	"dhcp":
	    description   => "$fqdn DHCP server",
	    pluginargs    => [ "-s $ipaddress -t 20" ],
	    require       => Exec["Setuid check_dhcp"],
	    servicegroups => "netservices";
    }
}
