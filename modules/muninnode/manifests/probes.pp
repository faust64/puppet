class muninnode::probes {
    muninnode::define::probe {
	$muninnode::vars::munin_probes:
    }

    if ($muninnode::vars::munin_time) {
	muninnode::define::probe {
	    $muninnode::vars::munin_time:
	}
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	muninnode::define::probe {
	    $muninnode::vars::munin_physical_probes:
	}

	if ($muninnode::vars::munin_sensors != false) {
	    each($muninnode::vars::munin_sensors) |$probe| {
		muninnode::define::probe {
		    "sensors_$probe":
			plugin_name => "sensors_";
		}
	    }
	}

	if ($muninnode::vars::mdraid != false) {
	    muninnode::define::probe {
		"raid":
	    }
	}
    } else {
	muninnode::define::probe {
	    $muninnode::vars::munin_physical_probes:
		status => absent;
	}
    }

    each(split($interfaces, ',')) |$nic| {
	if ($nic != lo and $nic != "lo0" and ! ($nic =~ /vif/)) {
	    muninnode::define::probe {
		"if_$nic":
		    plugin_name => "if_";
	    }
	}
    }

    if ($muninnode::vars::munin_purge_probes != false) {
	each($muninnode::vars::munin_purge_probes) |$probe| {
	    muninnode::define::probe {
		$probe:
		    status => "absent";
	    }
	}
    }

    if ($swapsize != undef and $swapsize =~ /[1-9]/) {
	muninnode::define::probe { "swap": }
    } else {
	muninnode::define::probe {
	    "swap":
		status => "absent";
	}
    }
}
