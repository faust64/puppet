define apt::define::repo($baseurl  = "http://ftp.debian.org/debian",
			 $branches = "main",
			 $codename = $lsbdistcodename,
			 $type     = "deb") {
    if (! defined(File["APT $name source.list"])) {
	if ($baseurl =~ /https:/) {
	    if (! defined(Common::Define::Package["apt-transport-https"])) {
		common::define::package {
		    "apt-transport-https":
		}
	    }

	    Package["apt-transport-https"]
		-> File["APT $name source.list"]

	    if (hiera("apt_cacher") != false) {
		$urlary = split($baseurl, '/')

		apt::define::bypass_proxy {
		    $name:
			host => $urlary[2];
		}
	    }
	}

	file {
	    "APT $name source.list":
		content => template("apt/source.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Exec["Update APT local cache"],
		owner   => root,
		path    => "/etc/apt/sources.list.d/$name.list",
		require => File["Prepare APT for further configuration"];
	}
    }
}
