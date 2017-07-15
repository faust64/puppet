class riak::nagios {
    include sudo

    $enterprise  = $riak::vars::enterprise
    $nagios_user = $riak::vars::nagios_runtime_user
    $sudo_conf_d = $riak::vars::sudo_conf_dir

    nagios::define::probe {
	"riak":
	    description   => "$fqdn riak",
	    servicegroups => "databases",
	    use           => "critical-service";
    }

    file {
	"Add nagios user to sudoers for riak test":
	    content => template("riak/nagios.sudoers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "$sudo_conf_d/sudoers.d/nagios-riak",
	    require => File["Prepare sudo for further configuration"];
    }

    if ($riak::vars::do_fullsync and $enterprise) {
	$conf_dir    = $riak::vars::nagios_conf_dir
	$do_ssl      = $riak::vars::riak_ssl
	$local_pass  = $riak::vars::nagios_local_pass
	$local_user  = $riak::vars::nagios_local_user
	$remote_fqdn = $riak::vars::nagios_remote_fqdn
	$remote_pass = $riak::vars::nagios_remote_pass
	$remote_user = $riak::vars::nagios_remote_user

	file {
	    "Install nagios riak_repl probe configuration":
		content => template("riak/nagios.erb"),
		group   => $riak::vars::nagios_runtime_group,
		mode    => "0640",
		owner   => root,
		path    => "$conf_dir/riak.cfg",
		require =>
		    [
			File["Add nagios user to sudoers for riak test"],
			Nagios::Define::Probe["riak"]
		    ];
	}

	nagios::define::probe {
	    "riak_repl":
		description   => "$fqdn riak replication",
		pluginconf    => "sudo",
		servicegroups => "databases",
		use           => "critical-service";
	}
    }
}
