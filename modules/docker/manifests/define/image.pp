define docker::define::image($ensure  = "present",
			     $image   = $name,
			     $timeout = 360) {
    if ($ensure == "present") {
	exec {
	    "Install docker image $name":
		command => "docker pull $image",
		cwd     => "/",
		unless  => "docker images | grep '^$image[ \t]'",
		path    => "/usr/bin:/bin",
		require => Package["docker.io"],
		timeout => $timeout;
	}
    } else {
	exec {
	    "Purge docker image $name":
		command => "docker rmi $image",
		cwd     => "/",
		onlyif  => "docker images | grep '^$image[ \t]'",
		path    => "/usr/bin:/bin";
	}
    }
}
