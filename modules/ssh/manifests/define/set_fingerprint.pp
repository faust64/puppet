define ssh::define::set_fingerprint($fingerprint = $name,
				    $home        = "/root",
				    $tag         = $fqdn,
				    $user        = "root") {
    @@common::define::lined {
	"Insert $hostname $name fingerprint":
	    line    => "$hostname,$ipaddress $fingerprint",
	    path    => "$home/.ssh/known_hosts",
	    require => File["Prepare $user known_hosts"],
	    tag     => "fingerprint-$user-$tag";
	"Insert $fqdn $name fingerprint":
	    line    => "$fqdn $fingerprint",
	    path    => "$home/.ssh/known_hosts",
	    require => File["Prepare $user known_hosts"],
	    tag     => "fingerprint-$user-$tag";
    }
}
