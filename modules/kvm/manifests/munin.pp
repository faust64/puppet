class kvm::munin {
    if ($kvm::vars::munin_probes) {
	if ($kvm::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    $conf_dir = $kvm::vars::munin_conf_dir

	    file {
		"Install KVM munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$kvm::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/kvm.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/kvm/munin.conf";
	    }

	    muninnode::define::probe {
		$kvm::vars::munin_probes:
		    require => File["Install KVM munin probe configuration"];
	    }
	}
    }
}
