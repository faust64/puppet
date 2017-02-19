class peerio::riakssl {
    each($peerio::vars::workers) |$worker| {
	if ($worker == "foreground" or $worker == "background"
	    or $worker == "schedule" or $worker == "admin"
	    or $worker == "filemgr" or $worker == "inferno") {
	    if (! defined(Pki::Define::Wrap["pm2"])
		and ! defined(Pki::Define::Wrap["pm2"])) {
		$conf_dir = $peerio::vars::conf_dir

		if (! defined(File["Prepare Peerio Riak SSL configuration directory"])) {
		    file {
			"Prepare Peerio Riak SSL configuration directory":
			    ensure  => directory,
			    group   => $peerio::vars::runtime_group,
			    mode    => "0750",
			    owner   => $peerio::vars::runtime_user,
			    path    => "$conf_dir/ssl",
			    require => File["Prepare Peerio for further configuration"];
		    }
		}

		pki::define::wrap {
		    "pm2":
			ca      => "riak",
			prefix  => "client",
			reqfile => "Prepare Peerio Riak SSL configuration directory",
			within  => "$conf_dir/ssl";
		}
	    }
	}
    }
}
