class miniflux::install {
    $runtime_user = $miniflux::vars::runtime_user
    $web_root     = $miniflux::vars::web_root

    common::define::geturl {
	"miniflux":
	    notify  => Exec["Extract miniflux server root"],
	    nomv    => true,
	    require =>
		[
		    Class["common::tools::unzip"],
		    File["Prepare www directory"]
		],
	    target  => "/root/miniflux-latest.zip",
	    url     => "https://miniflux.net/miniflux-latest.zip",
	    wd      => "/root";
    }

    exec {
	"Extract miniflux server root":
	    command     => "tar -xzf /root/miniflux-latest.zip",
	    cwd         => $web_root,
	    notify      => Exec["Set permissions to miniflux data directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set permissions to miniflux data directory":
	    command     => "chown -R $runtime_user data",
	    cwd         => "$web_root/miniflux",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
