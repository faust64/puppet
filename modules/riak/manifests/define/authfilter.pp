define riak::define::authfilter($sources = [ "127.0.0.1/32" ],
				$type    = "trust",
				$user    = "all") {
    if ($sources and $type and $user) {
	each($sources) |$filter| {
	    exec {
		"Allow Riak auth to $user ($type) from $filter":
		    command => "riak-admin security add-source $user $filter $type",
		    cwd     => "/",
		    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
		    require => Common::Define::Service["riak"],
		    unless  => "riak-admin security print-sources | grep -B3 '^|[^|]* $user[, ]' | grep '[| ]$type[| ]' | grep $filter";
	    }

	    Exec["Allow Riak auth to $user ($type) from $filter"]
		-> Exec["Ensure Riak security is enabled"]
	}
    }
}
