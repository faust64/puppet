define riak::define::user($ensure      = "present",
			  $ingroups    = false,
			  $password    = false,
			  $permissions = [ "kv_read" ],
			  $sources     = false) {
    if ($ensure == "present") {
	if ($password) {
	    $passwordstr = " password=$password"
	} else {
	    $passwordstr = ""
	}

	exec {
	    "Create Riak user $name":
		command => "riak-admin security add-user $name$passwordstr",
		cwd     => "/",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Common::Define::Service["riak"],
		unless  => "riak-admin security print-users | grep '^|[ ]*$name '";
	}

	Exec["Create Riak user $name"]
	    -> Exec["Ensure Riak security is enabled"]

	if ($ingroups) {
	    each($ingroups) |$groupname| {
		if (! defined(Riak::Define::Group[$groupname])) {
		    riak::define::group {
			$groupname:
		    }
		}

		Riak::Define::Group[$groupname]
		    -> Exec["Add Riak user $name to its groups"]
	    }

	    $ingroupsstr = join($ingroups, ',')

	    exec {
		"Add Riak user $name to its groups":
		    command => "riak-admin security alter-user $name 'groups=$ingroupsstr'",
		    cwd     => "/",
		    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Exec["Create Riak user $name"],
		    unless  => "riak-admin security print-users | grep '^|[ ]*$name ' | grep ' $ingroupsstr '";
	    }

	    Exec["Add Riak user $name to its groups"]
		-> Exec["Ensure Riak security is enabled"]
	}

	if ($sources) {
	    each($sources) |$filtername, $filtersource| {
		riak::define::authfilter {
		    "$name-$filtername":
			require => Exec["Create Riak user $name"],
			sources => $filtersource,
			type    => $filtername,
			user    => $name;
		}
	    }
	} else {
	    riak::define::authfilter {
		"$name-trust":
		    require => Exec["Create Riak user $name"],
		    user    => $name;
	    }
	}

	if ($permissions) {
	    each($permissions) |$profile| {
		riak::define::set_permissions {
		    "$name-$profile":
			profile => $profile,
			require => Exec["Create Riak user $name"],
			trustee => "user/$name";
		}
	    }
	} else {
	    each([ "bucket_read", "kv_read" ]) |$profile| {
		riak::define::set_permissions {
		    "$name-$profile":
			profile => $profile,
			require => Exec["Create Riak user $name"],
			trustee => "user/$name";
		}
	    }
	}
    } else {
	exec {
	    "Drop Riak user $name":
		command => "riak-admin security del-user $name",
		cwd     => "/",
		onlyif  => "riak-admin security print-users | grep '^|[ ]*$name '",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Common::Define::Service["riak"];
	}
    }
}
