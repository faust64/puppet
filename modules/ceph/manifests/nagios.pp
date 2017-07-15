class ceph::nagios {
    if ($ceph::vars::with_nagios) {
	include sudo

	$client      = $ceph::vars::nagios_ceph_client
	$keyring     = $ceph::vars::nagios_ceph_keyring_path
	$nagios_user = $ceph::vars::nagios_runtime_user
	$plugindir   = $ceph::vars::plugins_dir
	$sudo_conf_d = $ceph::vars::sudo_conf_dir

	nagios::define::probe {
	    "ceph_health":
		description => "$fqdn Ceph HEALTH",
		pluginargs  =>
		    [
			"--id $client",
			"--keyring /etc/ceph/$keyring"
		    ],
		require     => Common::Define::Package["ceph-common"],
		use         => "critical-service";
	}

	if ($ceph::vars::nagios_map != false) {
	    each($ceph::vars::nagios_map) |$hname, $ceph_node| {
		if ($ceph_node['mon'] == true) {
		    nagios::define::probe {
			"ceph_mon_$hname":
			    description => "$fqdn Ceph MON $hname",
			    pluginargs  =>
				[
				    "-H $hname",
				    "-I $hname"
				],
			    pluginconf  => "cephmon",
			    require     => Common::Define::Package["ceph-common"],
			    use         => "critical-service";
		    }
		}
		if ($ceph_node['osd'] != false) {
		    each(split($ceph_node['osd'], ',')) |$osd| {
			nagios::define::probe {
			    "ceph_osd_$osd":
				description => "$fqdn Ceph OSD #$osd",
				pluginargs  =>
				    [
					"-H $hname",
					"-I $osd"
				    ],
				pluginconf  => "cephosd",
				require     =>
				    [
					Common::Define::Package["ceph-common"],
					File["Add nagios user to sudoers for ceph querying"]
				    ],
				use         => "critical-service";
			}
		    }
		}
	    }
	}

	file {
	    "Add nagios user to sudoers for ceph querying":
		content => template("ceph/nagios.sudoers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_d/sudoers.d/nagios-ceph",
		require => File["Prepare sudo for further configuration"];
	}
    }
}
