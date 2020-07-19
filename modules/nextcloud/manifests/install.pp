class nextcloud::install {
    include common::tools::unzip

    $version  = $nextcloud::vars::version
    $webroot  = $nextcloud::vars::web_root
    if ($version != "latest") {
	$va   = $version.split('\.')
	$cv   = $va[0,3].join('.')
    } else {
	$cv   = $version
    }

    common::define::geturl {
	"NextCloud":
	    nomv    => true,
	    notify  => Exec["Extract NextCloud"],
	    target  => "/root/nextcloud-$cv.zip",
	    url     => "https://download.nextcloud.com/server/releases/nextcloud-$cv.zip",
	    wd      => "/root";
    }

    exec {
	"Extract NextCloud":
	    command     => "unzip /root/nextcloud-$cv.zip",
	    cwd         => "/var/www",
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => Class["common::tools::unzip"];
    }

    file {
	"Install NextCloud apps directory":
	    ensure  => directory,
	    group   => $nextcloud::vars::runtime_group,
	    mode    => "0755",
	    owner   => $nextcloud::vars::runtime_user,
	    path    => "$webroot/apps",
	    require => Exec["Extract NextCloud"];
	"Install NextCloud data directory":
	    ensure  => directory,
	    group   => $nextcloud::vars::runtime_group,
	    mode    => "0770",
	    owner   => $nextcloud::vars::runtime_user,
	    path    => "$webroot/data",
	    require => Exec["Extract NextCloud"];
    }

    if ($nextcloud::vars::web_root != "/var/www/nextcloud") {
	exec {
	    "Install NextCloud":
		command     => "mv nextcloud $webroot",
		creates     => $webroot,
		cwd         => "/var/www",
		path        => "/usr/bin:/bin",
		require     => Exec["Extract NextCloud"];
	}

	Exec["Install NextCloud"]
	    -> File["Prepare nextcloud for further configuration"]
    } else {
	Exec["Extract NextCloud"]
	    -> File["Prepare nextcloud for further configuration"]
    }
}
