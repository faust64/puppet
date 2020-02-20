define nagios::define::probe($args             = false,
			     $command          = "check_$name",
			     $contact_escalate = lookup("nagios_contact_escalate"),
			     $description      = "$fqdn $name",
			     $depexecfail      = "u,w,c",
                             $ensure           = "present",
			     $escalate_first   = 1,
			     $escalate_itv     = 20,
			     $escalate_last    = 2,
			     $escalate_opts    = "c",
			     $escalate_when    = "24x7",
			     $notiffail        = "u,w,c",
			     $dependency       = "$fqdn NRPE service",
			     $dephost          = $fqdn,
			     $is_nrpe          = true,
			     $pluginargs       = false,
			     $pluginconf       = "default",
			     $servicegroups    = false,
			     $targetdir        = "/etc/nagios/import.d",
			     $use              = "warning-service") {
    if ($is_nrpe) {
	$natport  = lookup("nagios_nrpe_nat_port")
	$realport = lookup("nagios_nrpe_port")
	if ($natport) {
	    if ($operatingsystem == "OpenBSD" and $kernelversion == "6.6") {
		$cmdhead = "check_nrpe_port_plain!$natport!$command"
	    } else {
		$cmdhead = "check_nrpe_port!$natport!$command"
	    }
	} elsif ($realport != 5666 and $realport != "5666") {
	    if ($operatingsystem == "OpenBSD" and $kernelversion == "6.6") {
		$cmdhead = "check_nrpe_port_plain!$realport!$command"
	    } else {
		$cmdhead = "check_nrpe_port!$realport!$command"
	    }
	} else {
	    if ($operatingsystem == "OpenBSD" and $kernelversion == "6.6") {
		$cmdhead = "check_nrpe_plain!$command"
	    } else {
		$cmdhead = "check_nrpe!$command"
	    }
	}
    } else { $cmdhead = $command }
    if ($args) {
	$cmdtail = join($args, '!')
	$cmd     = "$cmdhead!$cmdtail"
    } else { $cmd     = $cmdhead }
    $http_listen = lookup("apache_listen_ports")

    if ($pluginargs != false) {
	$preargs   = join($pluginargs, ' ')
	$pluginarg = " $preargs"
    } else { $pluginarg = "" }

    $conf_dir  = lookup("nagios_conf_dir")
    $plugindir = lookup("nagios_plugins_dir")

    if (lookup("with_nagios") == true) {
	if (! defined(Class[nagios])) {
	    include nagios
	}

	@@nagios_service {
	    "check_${name}_$fqdn":
		check_command       => $cmd,
		ensure              => $ensure,
		host_name           => $fqdn,
		notify              => Exec["Refresh Icinga configuration"],
		require             => File["Prepare nagios services probes import directory"],
		service_description => $description,
		servicegroups       => $servicegroups,
		tag                 => "nagios-$domain",
		target              => "$targetdir/services/${name}_$fqdn.cfg",
		use                 => $use;
	}

	if ($dependency != false) {
	    @@nagios_servicedependency {
		"check_${name}_$fqdn":
		    dependent_host_name           => $dephost,
		    dependent_service_description => $dependency,
		    ensure                        => $ensure,
		    execution_failure_criteria    => $depexecfail,
		    host_name                     => $fqdn,
		    inherits_parent               => 1,
		    notification_failure_criteria => $notiffail,
		    notify                        => Exec["Refresh Icinga configuration"],
		    require                       => File["Prepare nagios service-dependencies probes import directory"],
		    service_description           => $description,
		    tag                           => "nagios-$domain",
		    target                        => "$targetdir/service-dependencies/${name}_$fqdn.cfg";
	    }
	}

	if ($contact_escalate != false) {
	    @@nagios_serviceescalation {
		"check_${name}_$fqdn":
		    contact_groups        => $contact_escalate,
		    ensure                => $ensure,
		    escalation_options    => $escalate_opts,
		    escalation_period     => $escalate_when,
		    first_notification    => $escalate_first,
		    host_name             => $fqdn,
		    last_notification     => $escalate_last,
		    notification_interval => $escalate_itv,
		    notify                => Exec["Refresh Icinga configuration"],
		    require               => File["Prepare nagios service-escalations probes import directory"],
		    service_description   => $description,
		    tag                   => "nagios-$domain",
		    target                => "$targetdir/service-escalations/${name}_$fqdn.cfg";
	    }
	}

	if ($is_nrpe and $pluginconf != false) {
	    file {
		"Install Nagios $name configuration":
		    content => template("nagios/plugins/$pluginconf.erb"),
		    ensure  => $ensure,
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$nagios::vars::nrpe_service_name],
		    owner   => root,
		    path    => "$conf_dir/nrpe.d/$name.cfg",
		    require => File["Prepare nagios nrpe probes configuration directory"];
	    }
	} else {
	    file {
		"Drop Nagios $name configuration":
		    ensure  => absent,
		    force   => true,
		    notify  => Service[$nagios::vars::nrpe_service_name],
		    path    => "$conf_dir/nrpe.d/$name.cfg";
	    }
	}
    }
}
