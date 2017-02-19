class patchdashboard::register {
    $db_name  = "patchdashboard"
    $download = hiera("download_cmd")
    $upstream = hiera("patchdashboard_upstream")

    if ($upstream) {
	if (! defined(Class[curl])) {
	    include curl
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
		creates     => "/etc/cron.d/patch-manager",
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
