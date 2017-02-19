class tinytinyrss::install {
    $download     = $tinytinyrss::vars::download
    $runtime_user = $tinytinyrss::vars::runtime_user
    $web_root     = $tinytinyrss::vars::web_root

    exec {
	"Install tinytinyrss server root":
	    command     => "$download https://github.com/gothfox/Tiny-Tiny-RSS/archive/master.zip && mv master.zip tinytinyrss-latest.zip",
	    creates     => "/root/tinytinyrss-latest.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract tinytinyrss server root"],
	    path        => "/usr/bin:/bin",
	    require     =>
		[
		    Class[Common::Tools::Unzip],
		    File["Prepare www directory"]
		];
	"Extract tinytinyrss server root":
	    command     => "tar -xzf /root/tinytinyrss-latest.zip && mv Tiny-Tiny-RSS-master ttrss",
	    cwd         => $web_root,
	    notify      => Exec["Set permissions to tinytinyrss data directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set permissions to tinytinyrss data directory":
	    command     => "chown -R $runtime_user ttrss",
	    cwd         => $web_root,
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
