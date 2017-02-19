class riak::security {
    if ($riak::vars::security) {
	if ($riak::vars::security['groups']) {
	    create_resources(riak::define::group, $riak::vars::security['groups'])
	}
	if ($riak::vars::security['users']) {
	    create_resources(riak::define::user, $riak::vars::security['users'])
	}

	exec {
	    "Ensure Riak security is enabled":
		command => "riak-admin security enable",
		cwd     => "/",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		onlyif  => "riak-admin security status | grep Disabled";
	}
    }
}
