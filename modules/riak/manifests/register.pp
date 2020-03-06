class riak::register {
    $dcookie  = $riak::vars::dcookie
    $register = $riak::vars::register

    exec {
	"Join Riak cluster":
	    command => "riak_join_hack $dcookie@$register && riak_commit_hack && echo ok >riak-cluster-joined",
	    creates => "/root/riak-cluster-joined",
	    cwd     => "/root",
	    onlyif  => "riak ping | grep pong || ( sleep 3 ; riak ping | grep pong )",
	    path    => "/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    require =>
		[
		    Common::Define::Service["riak"],
		    File["Install Riak join script"],
		    File["Install Riak commit script"]
		];
    }
}
