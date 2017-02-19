class newznab::install {
    include common::libs::mediainfo
    include common::tools::unrar
    include subversion

    $web_root = $newznab::vars::web_root

    subversion::define::workdir {
	"nnplus":
	    local_container => $web_root,
	    local_name      => "nnplus",
	    repository      => "svn://svn.newznab.com/nn/branches/nnplus",
	    require         => File["Prepare www directory"],
	    svn_password    => $newznab::vars::svn_password,
	    svn_username    => $newznab::vars::svn_username,
	    update          => false;
    }

    exec {
	"Drop nnplus install menus":
	    command => "mv nnplus/www/install /root/nnplus-install-backup",
	    cwd     => $web_root,
	    onlyif  => "test -d nnplus/www/install",
	    path    => "/usr/bin:/bin",
	    require => Subversion::Define::Workdir["nnplus"];
    }

    file {
	"Set proper permissions to Newznab nzbfiles directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => $newznab::vars::runtime_user,
	    path    => "$web_root/nnplus/nzbfiles",
	    require => Subversion::Define::Workdir["nnplus"];
	"Set proper permissions to Newznab smartty cache":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => $newznab::vars::runtime_user,
	    path    => "$web_root/nnplus/www/lib/smarty/templates_c",
	    require => Subversion::Define::Workdir["nnplus"];
    }

    each([ "movies", "anime", "music", "tv" ]) |$folder| {
	file {
	    "Set proper permissions to Newznab $folder covers":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => $newznab::vars::runtime_user,
		path   => "$web_root/nnplus/www/covers/$folder",
		require => Subversion::Define::Workdir["nnplus"];
	}
    }
}
