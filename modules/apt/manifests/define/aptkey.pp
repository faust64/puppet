define apt::define::aptkey($keyid     = false,
			   $keyserver = "keyserver.ubuntu.com",
			   $url       = false) {
    if ($url) {
	exec {
	    "Import $url APT key":
		command => "wget -O - '$url' | apt-key add -",
		cwd     => "/",
		unless  => "apt-key list | grep '$name'",
		path    => "/usr/bin:/bin";
	}
    } elsif ($keyid) {
	exec {
	    "Import $keyid APT key":
		command => "apt-key adv --keyserver $keyserver --recv $keyid",
		cwd     => "/",
		unless  => "apt-key list | grep -E '($name|$keyid)'",
		path    => "/usr/bin:/bin";
	}
    }
}
