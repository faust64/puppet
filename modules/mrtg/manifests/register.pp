class mrtg::register {
    $mrtg_monitor    = lookup("mrtg_monitor")
    $snmp_community  = lookup("snmp_community")
    $snmp_listenaddr = lookup("snmp_listenaddr")

    if ($snmp_community and $mrtg_monitor) {
	@@file {
	    "Prepare mrtg $fqdn directory":
		ensure  => directory,
		mode    => "0755",
		owner   => root,
		path    => "/var/www/mrtg/$hostname",
		require => File["Install MRTG generic host template"],
		tag     => "MRTG-$mrtg_monitor";
	    "Link mrtg $fqdn configuration to cgi-bin runtime directory":
		ensure  => link,
		force   => true,
		path    => "/usr/lib/cgi-bin/$hostname.cfg",
		tag     => "MRTG-$mrtg_monitor",
		target  => "/var/www/mrtg/$hostname/$hostname.cfg",
		require => Exec["SNMP discover $fqdn"];
	}

	@@exec {
	    "SNMP discover $fqdn":
		command => "cfgmaker --global 'LogFormat: rrdtool' --global 'WorkDir: /var/www/mrtg/$hostname' --global 'Options[_]:bits,growright' --host-template=/var/www/mrtg/generic.htp --output /var/www/mrtg/$hostname/$hostname.cfg $snmp_community@$snmp_listenaddr",
		creates => "/var/www/mrtg/$hostname/$hostname.cfg",
		cwd     => "/var/www/mrtg",
		path    => "/usr/bin:/bin",
		require => File["Prepare mrtg $fqdn directory"],
		tag     => "MRTG-$mrtg_monitor";
	    "Link $fqdn for 14all.cgi":
		command => "ln /var/www/mrtg/$hostname/$hostname.cfg",
		creates => "/usr/lib/cgi-bin/$hostname.cfg",
		cwd     => "/usr/lib/cgi-bin",
		path    => "/usr/bin:/bin",
		require => Exec["SNMP discover $fqdn"],
		tag     => "MRTG-$mrtg_monitor";
	}
    }
}
