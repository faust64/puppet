class pf::nagios {
    include sudo

    $nagios_user = $pf::vars::nagios_runtime_user
    $sudo_conf_d = $pf::vars::sudo_conf_dir

    each($pf::vars::main_networks) |$nic| {
	if ($nic['gw']) {
	    if ($nic['carpaddr']) {
		$check_addr = $nic['carpaddr']
	    }
	    else {
		$check_addr = $nic['addr']
	    }

	    pf::define::check_link {
		$nic['name']:
		    local => $check_addr;
	    }
	}
    }

    nagios::define::probe {
	"pf_states":
	    description   => "$fqdn pf states",
	    pluginargs    => [ "general" ],
	    servicegroups => "network",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for pfctl states listing":
	    content => template("pf/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-pf",
	    require => File["Prepare sudo for further configuration"];
    }
}
