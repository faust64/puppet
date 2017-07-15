define subversion::define::workdir($group_real      = lookup("gid_zero"),
				   $local_container = false,
				   $local_name      = $name,
				   $owner_real      = "root",
				   $repository      = false,
				   $svn_password    = false,
				   $svn_username    = false,
				   $update          = true) {
    if ($local_container and $repository) {
	$local_name_real = $local_name ? { false => $name, default => $local_name }

	if (!defined(Class[Subversion])) {
	    include subversion
	}

	$retrieve_command = $svn_username ? {
		false   => "svn checkout --non-interactive '$repository' '$local_name_real'",
		default => "svn checkout --non-interactive --username='$svn_username' --password='$svn_password' '$repository' '$local_name_real'"
	    }
	$check_command = $svn_username ? {
		false   => "svn status -u --non-interactive '$local_name_real' | grep '*'",
		default => "svn status -u --non-interactive --username='$svn_username' --password='$svn_password' '$local_name_real' | grep '*'"
	    }
	$update_command = $svn_username ? {
		false   => "svn update --non-interactive '$local_name_real'",
		default => "svn update --non-interactive --username='$svn_username' --password='$svn_password' '$local_name_real'"
	    }

	exec {
	    "SVN Checkout $name":
		command => $retrieve_command,
		creates => "$local_container/$local_name_real/.svn",
		cwd     => $local_container,
		path    => "/usr/local/bin:/usr/bin:/bin",
		require => Package["subversion"];
	}

	if ($update == true) {
	    exec {
		"SVN Update $name":
		    command => $update_command,
		    cwd     => $local_container,
		    onlyif  => $check_command,
		    path    => "/usr/local/bin:/usr/bin:/bin",
		    require => Exec["SVN Checkout $name"];
	    }
	}
    }
}
