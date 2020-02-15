class patchdashboard::register {
    $db_name  = "patchdashboard"
    $download = lookup("download_cmd")
    $upstream = lookup("patchdashboard_upstream")

    if ($upstream) {
	if (! defined(Class[curl])) {
	    include curl

	    Class["curl"]
		-> Exec["Download PatchDashboard client installer"]
	}

	if ($myoperatingsystem == "Debian" or $myoperatingsystem == "Devuan" or $myoperatingsystem == "Ubuntu") {
	    file {
		"Schedule daily apt updates":
		    group  => lookup("gid_zero"),
		    mode     => "0755",
		    owner  => "root",
		    path   => "/etc/cron.daily/aptupdate",
		    source => "puppet:///modules/patchdashboard/cron-deb";
	    }

	    File["Schedule daily apt updates"]
		-> Exec["Download PatchDashboard client installer"]
	}

	if ($operatingsystem == "OpenBSD" or $operatingsystem == "FreeBSD") {
	    if (! defined(Common::Define::Package["bash"])) {
		common::define::package {
		    "bash":
		}
	    }

	    common::define::lined {
		"Fix PatchDashboard registration script":
		    line    => "#!/usr/bin/env bash",
		    match   => "^#!/",
		    path    => "/root/patchdashboard-register.sh",
		    require => Exec["Download PatchDashboard client installer"];
	    }

	    Common::Define::Package["bash"]
		-> Exec["Install PatchDashboard client"]

	    Common::Define::Lined["Fix PatchDashboard registration script"]
		-> Exec["Install PatchDashboard client"]
	    $mark_installed = "/opt/patch_manager/check-in.sh"

	    cron {
		"Check-in with PatchDashboard":
		    command => "/opt/patch_manager/check-in.sh",
		    hour    => "*",
		    minute  => "*/2",
		    require => Exec["Install PatchDashboard client"],
		    user    => root;
	    }
	} else {
	    $mark_installed = "/etc/cron.d/patch-manager"
	}

	exec {
	    "Download PatchDashboard client installer":
		command => "$download https://$upstream/client/client_installer.php && mv client_installer.php patchdashboard-register.sh && chmod +x patchdashboard-register.sh",
		cwd     => "/root",
		creates => "/root/patchdashboard-register.sh",
		path    => "/usr/bin:/bin";
	    "Install PatchDashboard client":
		command     => "patchdashboard-register.sh",
		cwd         => "/",
		creates     => $mark_installed,
		notify      => Exec["Register to PatchDashboard"],
		path        => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/root",
		require     => Exec["Download PatchDashboard client installer"];
	    "Register to PatchDashboard":
		command     => "check-in.sh",
		cwd         => "/",
		path        => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin:/opt/patch_manager",
		refreshonly => true;
	}

	if (defined(Common::Define::Package["curl"])) {
	    Common::Define::Package["curl"]
		-> Exec["Register to PatchDashboard"]
	    Common::Define::Package["curl"]
		-> Exec["Install PatchDashboard client"]
	}

	@@exec {
	    "Trust $fqdn on PatchDashboard":
		command => "echo \"UPDATE servers SET trusted = 1 WHERE server_name = '$fqdn'\" | mysql -u root $db_name",
		cwd     => "/",
		onlyif  => "echo \"SELECT trusted FROM servers WHERE server_name = '$fqdn'\" | mysql -Nu root $db_name | grep 0",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		require => Mysql::Define::Create_database[$db_name],
		tag     => "patchdashboard-$upstream";
	}
    }
}
