define riak::define::bucket_type($action = "create",
				 $object = false,
				 $what   = "counters") {
    if ($object != false) {
	case $action {
	    "activate": {
		$checkcmd = "riak-admin bucket-type status $what | grep 'active: false'"
	    }
	    "create": {
		$checkcmd = "riak-admin bucket-type status $what | grep active"
	    }
	    "deactivate": {
		$checkcmd = "riak-admin bucket-type status $what | grep 'active: true'"
	    }
	    default: {
		$checkcmd = "echo 0"
	    }
	}

	if ($action == "create") {
	    exec {
		"Riak $action $what to $object":
		    command     => "riak-admin bucket-type $action $what '$object'",
		    cwd         => "/",
		    notify      => Exec["Activate riak $what"],
		    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require     => Service["riak"],
		    unless      => $checkcmd;
		"Activate riak $what":
		    cwd         => "/",
		    command     => "riak-admin bucket-type activate $what",
		    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
		    refreshonly => true;
	    }
	} else {
	    exec {
		"Riak $action $what to $object":
		    command => "riak-admin bucket-type $action $what '$object'",
		    cwd     => "/",
		    onlyif  => $checkcmd,
		    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Service["riak"];
	    }
	}
    }
}
