class selfoss::install {
    $download     = $selfoss::vars::download
    $runtime_user = $selfoss::vars::runtime_user
    $web_root     = $selfoss::vars::web_root

    exec {
	"Install selfoss server root":
	    command     => "$download https://github.com/SSilence/selfoss/archive/master.zip && mv master.zip selfoss-latest.zip",
	    creates     => "/root/selfoss-latest.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract selfoss server root"],
	    path        => "/usr/bin:/bin",
	    require     =>
		[
		    Class[Apache],
		    Class[Common::Tools::Unzip],
		    File["Prepare www directory"]
		];
	"Extract selfoss server root":
	    command     => "tar -xzf /root/selfoss-latest.zip && mv selfoss-master selfoss",
	    cwd         => $web_root,
	    notify      =>
		[
		    Exec["Set permissions to selfoss public directory"],
		    Exec["Set permissions to selfoss runtime directories"]
		],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set permissions to selfoss public directory":
	    command     => "chown -R $runtime_user public",
	    cwd         => "$web_root/selfoss",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set permissions to selfoss runtime directories":
	    command     => "chown $runtime_user cache favicons logs thumbnails sqlite",
	    cwd         => "$web_root/selfoss/data",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
