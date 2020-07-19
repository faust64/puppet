class mysql::munin {
    if ($mysql::vars::munin_probes or $mysql::vars::munin_multi_probes) {
	if ($mysql::vars::munin_monitored) {
	    if (! defined(Class["muninnode"])) {
		include muninnode
	    }

	    include common::libs::perlcachecache

	    $conf_dir = $mysql::vars::munin_conf_dir

	    if ($mysql::vars::munin_probes) {
		muninnode::define::probe {
		    $mysql::vars::munin_probes:
			require => File["Install mysql munin probe configuration"];
		}
	    } else {
		muninnode::define::probe {
		    $mysql::vars::munin_probes:
			status => "absent";
		}
	    }
	    if ($mysql::vars::munin_multi_probes) {
		muninnode::define::probe {
		    $mysql::vars::munin_multi_probes:
			plugin_name => "mysql_",
			require     => File["Install mysql munin probe configuration"];
		}
	    } else {
		muninnode::define::probe {
		    $mysql::vars::munin_multi_probes:
			status => "absent";
		}
	    }
	    if ($mysql::vars::munin_do_myisam_db) {
		$do_myisam  = $mysql::vars::munin_do_myisam_db
		$probesstr  = inline_template("mysql_isam_space_<%=@do_myisam.join(',mysql_isam_space_')%>")
		$isamprobes = split($probes, ',')
		muninnode::define::probe {
		    $isamprobes:
			plugin_name => "mysql_isam_space_",
			require     => File["Install mysql munin probe configuration"];
		    $mysql::vars::munin_myisam_probes:
			require     => File["Install mysql munin probe configuration"];
		}
	    } else {
		muninnode::define::probe {
		    "mysql_innodb":
			require     => File["Install mysql munin probe configuration"];
		    $mysql::vars::munin_innodb_probes:
			plugin_name => "mysql_",
			require     => File["Install mysql munin probe configuration"];
		}
	    }

	    file {
		"Install mysql munin probe configuration":
		    content => template("mysql/munin.erb"),
		    group   => lookup("gid_zero"),
		    mode    => "0644",
		    notify  => Service[$mysql::vars::munin_service_name],
		    owner   => root,
		    path    => "$conf_dir/plugin-conf.d/mysql.conf",
		    require => File["Prepare Munin-node plugin-conf directory"];
	    }
	} else {
	    muninnode::define::probe {
		"mysql_innodb":
		    status => "absent";
		$mysql::vars::munin_innodb_probes:
		    status => "absent";
		$mysql::vars::munin_multi_probes:
		    status => "absent";
		$mysql::vars::munin_myisam_probes:
		    status => "absent";
		$mysql::vars::munin_probes:
		    status => "absent";
	    }
	}
    }
}
