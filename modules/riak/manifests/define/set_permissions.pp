define riak::define::set_permissions($bucketname = false,
				     $buckettype = "any",
				     $grant      = false,
				     $profile    = "kv_all",
				     $trustee    = "all") {
    if ($bucketname) {
	$onoption = "$buckettype $bucketname"
    } else {
	$onoption = $buckettype
    }
    if ($grant) {
	$grantarray = [ $grant ]
    } else {
	case $profile {
	    "bucket_all": {
		$grantarray = [ "riak_core.get_bucket", "riak_core.set_bucket",
				"riak_core.get_bucket_type", "riak_core.set_bucket_type" ]
	    }
	    "bucket_read": {
		$grantarray = [ "riak_core.get_bucket", "riak_core.get_bucket_type" ]
	    }
	    "kv_all": {
		$grantarray = [ "riak_kv.get", "riak_kv.put", "riak_kv.delete",
				"riak_kv.index", "riak_kv.list_keys",
				"riak_kv.list_buckets" ]
	    }
	    "kv_read": {
		$grantarray = [ "riak_kv.get", "riak_kv.list_keys",
				"riak_kv.list_buckets" ]
	    }
	    "mapreduce": {
		$grantarray = [ "riak_kv.mapreduce" ]
	    }
	    "search_all": {
		$grantarray = [ "search.admin", "search.query" ]
	    }
	    "search_read": {
		$grantarray = [ "search.query" ]
	    }
	    default: {
		notify{ "Riak set_permission $name: undefined profile $profile": }
	    }
	}
    }

    each($grantarray) |$grantcmd| {
	exec {
	    "Grant $trustee with $grantcmd":
		command => "riak-admin security grant $grantcmd on $onoption to $trustee",
		cwd     => "/",
		path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		require => Common::Define::Service["riak"],
		unless  => "riak-admin security print-grants $trustee | grep $grantcmd";
	}

	Exec["Grant $trustee with $grantcmd"]
	    -> Exec["Ensure Riak security is enabled"]
    }
}
