define katello::define::usergroup($admin      = false,
				  $authsource = false,
				  $base       = $openldap::vars::ldap_suffix,
				  $ensure     = 'present',
				  $ldapgroup  = false,
				  $loc        = $katello::vars::katello_loc,
				  $org        = $katello::vars::katello_org,
				  $roles      = false,
				  $source     = $openldap::vars::ldap_slave) {
    if ($ensure == 'present') {
	if ($admin) {
	    $adm = " --admin yes"
	} else { $adm = "" }

	exec {
	    "Install User-Group $name":
		command     => "hammer user-group create --name '$name' --organization '$org' --location '$loc'$adm",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer user-group list",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"],
		unless      => "hammer user-group info --name '$name'";
	}

	if ($ldapgroup != false and $authsource != false) {
	    exec {
		"Maps User-Group $name to LDAP group $ldapgroup":
		    command     => "hammer user-group external create --name '$ldapgroup' --user-group '$name' --auth-source '$authsource'",
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     =>
			[
			    Exec["Install User-Group $name"],
			    Katello::Define::Authsource[$authsource]
			],
		    unless      => "hammer user-group external info --id '$ldapgroup' --user-group '$name'";
	    }
	}

	if ($roles) {
	    each($roles) |$role| {
		exec {
		    "Add Role $role to User-Group $name":
			command     => "hammer user-group add-role --name '$name' --role '$role'",
			environment => [ 'HOME=/root' ],
			path        => "/usr/bin:/bin",
			require     => Exec["Install User-Group $name"],
			unless      => "hammer user-group info --name '$name' | grep '$role'";
		}
	    }
	}
    } else {
	exec {
	    "Drop User-Group $name":
		command     => "hammer user-group delete --name '$name'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer user-group info --name '$name'",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
