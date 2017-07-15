class peerio::service {
    if (! defined(Class[sudo])) {
	include sudo
    }

    if (! defined(File["Install pm2 init sudoers"])) {
	if ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty") {
	    $pm2inst  = "ubuntu"
	} else {
	    $pm2inst  = "systemd"
	}
	$runtime_user = $peerio::vars::runtime_user
	$sudo_conf_d  = $peerio::vars::sudo_conf_dir

	file {
	    "Install pm2 init sudoers":
		content => template("peerio/init.sudoers.erb"),
		group   => lookup("gid_zero"),
		mode    => "0440",
		owner   => root,
		path    => "$sudo_conf_d/sudoers.d/pm2-$runtime_user",
		require => Class["sudo"];
	}

	exec {
	    "Install pm2 systemd service":
		command     => "sudo pm2 startup systemd",
		cwd         => "/",
		environment => [ "PM2_HOME=/var/lib/pm2/.pm2" ],
		path        => "/usr/local/bin:/usr/bin:/bin",
		require     => File["Install pm2 init sudoers"],
		unless      => "test -s /lib/systemd/system/pm2.service",
		user        => $runtime_user;
	}

	Exec["Install pm2 systemd service"]
	    -> Common::Define::Service["pm2"]
    }

    common::define::service {
	"pm2":
	    ensure => running;
    }

    each($peerio::vars::workers) |$worker| {
	if ($worker == "foreground" or $worker == "filemgr" or $worker == "admin"
	    or $worker == "schedule" or $worker == "background") {
	    if (! defined(Exec["Refresh peerio-server"])) {
		exec {
		    "Refresh peerio-server":
			command     => "peerio-server refresh",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			refreshonly => true,
			subscribe   => File["Install Peerio main configuration"];
		    "Ensure peerio-server running":
			command     => "peerio-server restart",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			unless      => "peerio-server status",
			require     => Exec["Refresh peerio-server"];
		}

		Exec["Refresh peerio-server"]
		    -> Exec["Install pm2 systemd service"]
	    }
	    if ($worker == "admin" and $peerio::vars::zendesk
		and $peerio::vars::zendesk['account']
		and $peerio::vars::zendesk['email']
		and $peerio::vars::zendesk['key']
		and $peerio::vars::shark_name) {
		if (! defined(File["Install Zendesk hourly job"])) {
		    file {
			"Install Zendesk hourly job":
			    group   => lookup("gid_zero"),
			    mode    => "0755",
			    owner   => root,
			    path    => "/etc/cron.daily/zendesk-shark",
			    require => Exec["Refresh peerio-server"],
			    source  => "puppet:///modules/peerio/cron.hourly";
		    }
		}
	    }
	    if ($worker == "admin") {
		if (! defined(File["Install Stats daily job"])) {
		    file {
			"Install Stats daily job":
			    group   => lookup("gid_zero"),
			    mode    => "0755",
			    owner   => root,
			    path    => "/etc/cron.daily/peerio-stats",
			    require => Exec["Refresh peerio-server"],
			    source  => "puppet:///modules/peerio/cron.daily";
		    }
		}
	    }
	    if ($worker == "background") {
		if (! defined(File["Install Kuemanager weekly job"])) {
		    file {
			"Install Kuemanager weekly job":
			    group   => lookup("gid_zero"),
			    mode    => "0755",
			    owner   => root,
			    path    => "/etc/cron.weekly/peerio-redis",
			    require => Exec["Refresh peerio-server"],
			    source  => "puppet:///modules/peerio/cron.weekly";
		    }
		}
	    }
	} elsif ($worker == "inferno") {
	    if (! defined(Exec["Refresh peerio-inferno"])) {
		exec {
		    "Refresh peerio-inferno":
			command     => "peerio-inferno refresh",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			refreshonly => true,
			subscribe   => File["Install Peerio main configuration"];
		    "Ensure peerio-inferno running":
			command     => "peerio-inferno restart",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			unless      => "peerio-inferno status",
			require     => Exec["Refresh peerio-inferno"];
		}

		Exec["Refresh peerio-inferno"]
		    -> Exec["Install pm2 systemd service"]
	    }
	} elsif ($worker == "shark") {
	    if (! defined(Exec["Refresh peerio-shark"])) {
		exec {
		    "Refresh peerio-shark":
			command     => "peerio-shark refresh",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			refreshonly => true,
			subscribe   => File["Install Peerio main configuration"];
		    "Ensure peerio-shark running":
			command     => "peerio-shark restart",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			unless      => "peerio-shark status",
			require     => Exec["Refresh peerio-shark"];
		}

		Exec["Refresh peerio-shark"]
		    -> Exec["Install pm2 systemd service"]
	    }
	} elsif ($worker == "nuts") {
	    if (! defined(Exec["Refresh peerio-nuts"])) {
		exec {
		    "Refresh peerio-nuts":
			command     => "peerio-nuts refresh",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			refreshonly => true,
			subscribe   => File["Install Peerio main configuration"];
		    "Ensure peerio-nuts running":
			command     => "peerio-nuts restart",
			cwd         => "/",
			path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin/:/bin",
			unless      => "peerio-nuts status",
			require     => Exec["Refresh peerio-nuts"];
		}

		Exec["Refresh peerio-nuts"]
		    -> Exec["Install pm2 systemd service"]
	    }
	} elsif (! defined(Common::Define::Patchneeded["peerio-$worker"])) {
	    common::define::patchneeded { "peerio-$worker": }
	}
    }
}
