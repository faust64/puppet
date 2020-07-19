class zfs::munin {
    if ($zfs::vars::munin_probes) {
	if ($zfs::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    $conf_dir = $zfs::vars::munin_conf_dir

	    muninnode::define::probe {
		$zfs::vars::munin_fs_probes:
		    plugin_name => "zfs_fs_";
		$zfs::vars::munin_stats_probes:
		    plugin_name => "zfs_stats_";
		$zfs::vars::munin_probes:
		    require     => File["Install zfs munin probe configuration"];
	    }

	    file {
		"Install zfs munin probe configuration":
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$zfs::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/zfs.conf",
		    require => File["Prepare Munin-node plugin-conf directory"],
		    source  => "puppet:///modules/zfs/munin.conf";
	    }
	} else {
	    muninnode::define::probe {
		$zfs::vars::munin_fs_probes:
		    status => "absent";
		$zfs::vars::munin_stats_probes:
		    status => "absent";
		$zfs::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
