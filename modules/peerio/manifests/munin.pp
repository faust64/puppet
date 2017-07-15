class peerio::munin {
    if ($peerio::vars::munin_probesadm and $peerio::vars::munin_probesbg
	and $peerio::vars::munin_probesfg and $peerio::vars::munin_probesshark) {
	if ($peerio::vars::munin_monitored) {
	    if (! defined(Class[Muninnode])) {
		include muninnode
	    }

	    $conf_dir       = $peerio::vars::munin_conf_dir
	    $redis_backends = $peerio::vars::redis_backends
	    $redis_probes   = $peerio::vars::redis_munin_probes
	    $runtime_group  = $peerio::vars::runtime_group
	    $runtime_user   = $peerio::vars::runtime_user

	    each($peerio::vars::workers) |$worker| {
		if ($worker == "foreground" or $worker == "background") {
		    if (! defined(Class[Common::Tools::Redis])) {
			include common::tools::redis
		    }
		    if ($worker == "background") {
			if (! defined(Class[Common::Libs::Perlswitch])) {
			    include common::libs::perlswitch
			}
		    }
		}
		if ($worker == "foreground") {
		    muninnode::define::probe {
			$peerio::vars::munin_probesfg:
			    plugin_name => "peerio_",
			    require     =>
				[
				    File["Install peerio munin probes configuration"],
				    Class[Common::Libs::Perlswitch]
				];
		    }
		} elsif ($worker == "background") {
		    if ($redis_backends) {
			each($redis_backends) |$remote| {
			    $sname = regsubst($remote, '\.', '-', 'G')
			    each ($redis_probes) |$probe| {
				muninnode::define::probe {
				    "${sname}_$probe":
					plugin_name => "redis_",
					require     =>
					    [
						File["Install Redis backends munin configuration"],
						Class[Common::Libs::Perlswitch],
						Class[Common::Tools::Redis]
					    ];
				}
			    }
			}

			file {
			    "Install Redis backends munin configuration":
				content => template("peerio/munin-redis.erb"),
				group   => lookup("gid_zero"),
				mode    => "0644",
				notify  => Service[$peerio::vars::munin_service_name],
				owner   => root,
				path    => "$conf_dir/plugin-conf.d/peerio-redis.conf",
				require => File["Prepare Munin-node plugin-conf directory"];
			}
		    }

		    muninnode::define::probe {
			$peerio::vars::munin_probesbg:
			    plugin_name => "peerio_",
			    require     =>
				[
				    File["Install peerio munin probes configuration"],
				    Class[Common::Libs::Perlswitch]
				];
		    }
		} elsif ($worker == "admin") {
		    muninnode::define::probe {
			$peerio::vars::munin_probesadm:
			    plugin_name => "peerio_",
			    require     => File["Install peerio munin probes configuration"];
		    }
		    if ($peerio::vars::shark_name) {
			muninnode::define::probe {
			    $peerio::vars::munin_probesshark:
				plugin_name => "shark_",
				require     => File["Install peerio munin probes configuration"];
			}
		    }
		}
	    }

	    file {
		"Install peerio munin probes configuration":
		    content => template("peerio/munin-peerio.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$peerio::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/peerio.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		$peerio::vars::munin_probesadmin:
		    status => "absent";
		$peerio::vars::munin_probesbg:
		    status => "absent";
		$peerio::vars::munin_probesfg:
		    status => "absent";
		$peerio::vars::munin_probesshark:
		    status => "absent";
	    }
	}
    }
}
