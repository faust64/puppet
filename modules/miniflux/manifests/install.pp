class miniflux::install {
    $download     = $miniflux::vars::download
    $runtime_user = $miniflux::vars::runtime_user
    $web_root     = $miniflux::vars::web_root

    exec {
	"Install miniflux server root":
	    command     => "$download https://miniflux.net/miniflux-latest.zip",
	    creates     => "/root/miniflux-latest.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract miniflux server root"],
	    path        => "/usr/bin:/bin",
	    require     =>
		[
		    Class[Common::Tools::Unzip],
		    File["Prepare www directory"]
		];
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
