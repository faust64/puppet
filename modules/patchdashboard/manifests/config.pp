class patchdashboard::config {
    $company = $patchdashboard::vars::company
    $db_name = $patchdashboard::vars::db_name
    $db_pass = $patchdashboard::vars::db_pass
    $db_user = $patchdashboard::vars::db_user
    $salt    = $patchdashboard::vars::salt

    file {
	"Install PatchDashboard database configuration":
	    content => template("patchdashboard/db.erb"),
	    group   => $patchdashboard::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "/usr/share/patchdashboard/html/lib/db_config.php",
	    require => Git::Define::Clone["patchdashboard"];
	"Install PatchDashboard shell database configuration":
	    content => template("patchdashboard/db-tiny.erb"),
	    group   => $patchdashboard::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "/usr/share/patchdashboard/db.conf",
	    require => Git::Define::Clone["patchdashboard"];
    }

    each([ "patch_checker", "check-in", "package_checker", "run_commands" ]) |$script| {
	exec {
	    "Set server authkey into $script":
		command => "sed -i \"s|__SERVER_AUTHKEY_SET_ME__|`echo SELECT install_key FROM company LIMIT 1 | mysql -Nu root $db_name | xargs printf`|g\" $script.sh",
		cwd     => "/usr/share/patchdashboard/html/client",
		onlyif  => "grep __SERVER_AUTHKEY_SET_ME__ $script.sh",
		path    => "/usr/bin:/bin",
		require =>
		    [
			Exec["Create Company"],
			Git::Define::Clone["patchdashboard"]
		    ];
	    "Set server uri into $script":
		command => "sed -i 's|__SERVER_URI_SET_ME__|https://$fqdn/|' $script.sh",
		cwd     => "/usr/share/patchdashboard/html/client",
		onlyif  => "grep __SERVER_URI_SET_ME__ $script.sh",
		path    => "/usr/bin:/bin",
		require =>
		    [
			Exec["Create Company"],
			Git::Define::Clone["patchdashboard"]
		    ];
	}
    }
}
