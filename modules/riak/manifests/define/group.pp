define riak::define::group($ensure = "present") {
    if ($ensure == "present") {
	exec {
	    "Create Riak group $name":
		command => "riak-admin security add-group $name",
		cwd     => "/",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Service["riak"],
		unless  => "riak-admin security print-groups | grep '^|[ ]*$name '";
	}

	Exec["Create Riak group $name"]
	    -> Exec["Ensure Riak security is enabled"]
    } else {
	exec {
	    "Drop Riak group $name":
		command => "riak-admin security del-group $name",
		cwd     => "/",
		onlyif  => "riak-admin security print-groups | grep '^|[ ]*$name '",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Service["riak"];
	}
    }
}
