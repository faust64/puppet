define docker::define::image($ensure = "present",
			     $image = $name) {
    if ($ensure == "present") {
	exec {
	    "Install docker image $name":
		command => "docker pull $image",
		cwd     => "/",
		unless  => "docker images | grep '^$image[ \t]'",
		path    => "/usr/bin:/bin",
		require => Package["docker.io"],
    #pulling images can take time, especially with my ADSL throughput, ...
		timeout => 1800;
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
