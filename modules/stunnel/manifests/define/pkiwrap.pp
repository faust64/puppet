define stunnel::define::pkiwrap($ca = "web",
				$do = "ca") {
    file {
	"Prepare stunnel $name certificates directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/stunnel/ssl/$name",
	    require => File["Prepare stunnel certificates directory"];
    }

    pki::define::wrap {
	lookup("stunnel_service_name"):
	    ca      => $ca,
	    do      => $do,
	    group   => lookup("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    reqfile => "Prepare stunnel $name certificates directory",
	    within  => "/etc/stunnel/ssl/$name";
    }
}
