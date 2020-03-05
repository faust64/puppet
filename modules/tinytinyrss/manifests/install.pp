class tinytinyrss::install {
    $runtime_user = $tinytinyrss::vars::runtime_user
    $web_root     = $tinytinyrss::vars::web_root

    common::define::geturl {
	"tinytinyrss":
	    notify  => Exec["Extract tinytinyrss server root"],
	    require =>
		[
		    Class[Common::Tools::Unzip],
		    File["Prepare www directory"]
		],
	    target  => "/root/tinytinyrss-latest.zip",
	    url     => "https://github.com/gothfox/Tiny-Tiny-RSS/archive/master.zip",
	    wd      => "/root";
    }

    exec {
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
