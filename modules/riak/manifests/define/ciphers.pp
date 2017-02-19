define riak::define::ciphers($ciphers = hiera("riak_ciphers")) {
    $ciphersstr = join($ciphers, ':')

    exec {
	"Set Riak Ciphers":
	    command => "riak-admin security ciphers $ciphersstr",
	    cwd     => "/",
	    path    => "/usr/sbin:/usr/bin:/sbin:/bin",
	    require => Service["riak"],
	    unless  => "riak-admin security ciphers | grep '^$ciphersstr'";
    }
}
