class airsonic::register {
    $ssh_port = $airsonic::vars::ssh_port

    @@file {
	"Register $fqdn for airsonic sync":
	    content => template("airsonic/clientsync.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/var/airsonic/remotes/$fqdn",
	    require => File["Prepare airsonic remotes directory"],
	    tag     => "airsonic-sync-libraries";
    }

    if ($hostfingerprint != "") {
	ssh::define::set_fingerprint {
	    "airsonic-$hostfingerprint":
		fingerprint => $hostfingerprint,
		tag         => "airsonic";
	}
    }
}
