class lilina::install {
    $download     = $lilina::vars::download
    $runtime_user = $lilina::vars::runtime_user
    $web_root     = $lilina::vars::web_root

    exec {
	"Install lilina server root":
	    command     => "$download https://github.com/Lilina/Lilina/zipball/master && mv master lilina-latest.zip",
	    creates     => "/root/lilina-latest.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract lilina server root"],
	    path        => "/usr/bin:/bin",
	    require     =>
		[
		    Class[Common::Tools::Unzip],
		    File["Prepare www directory"]
		];
	"Extract lilina server root":
	    command     => "tar -xzf /root/lilina-latest.zip && mv Lilina* lilina",
	    cwd         => $web_root,
	    notify      =>
		[
		    Exec["Set permissions to lilina runtime directory"],
		    Exec["Cleanup lilina web root"]
		],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Cleanup lilina web root":
	    command     => "rm -f readme.html CREDITS",
	    cwd         => "$web_root/lilina",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Set permissions to lilina runtime directory":
	    command     => "chown -R $runtime_user system",
	    cwd         => "$web_root/lilina/content",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Drop installation files":
	    command     => "rm -f install.php install.css",
	    cwd         => "$web_root/lilina",
	    onlyif      => "test -s install.php -a -s content/system/config/settings.php",
	    path        => "/usr/bin:/bin";
    }
}
