class subsonic::register {
    $ssh_port = $subsonic::vars::ssh_port

    @@file {
	"Register $fqdn for subsonic sync":
	    content => template("subsonic/clientsync.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/var/subsonic/remotes/$fqdn",
	    require => File["Prepare subsonic remotes directory"],
	    tag     => "subsonic-sync-libraries";
    }

    if ($hostfingerprint != "") {
	ssh::define::set_fingerprint {
	    "subsonic-$hostfingerprint":
		fingerprint => $hostfingerprint,
		tag         => "subsonic";
	}
    }
}
