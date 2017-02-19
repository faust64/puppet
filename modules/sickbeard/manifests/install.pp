class sickbeard::install {
    $download     = $sickbeard::vars::download
    $home_dir     = $sickbeard::vars::home_dir
    $runtime_user = $sickbeard::vars::runtime_user

    group {
	$sickbeard::vars::runtime_group:
	   ensure => present;
    }

    user {
	$runtime_user:
	    gid     => $sickbeard::vars::runtime_group,
	    require => Group[$sickbeard::vars::runtime_group];
    }

    exec {
	"Download sickbeard from github":
	    command     => "$download https://github.com/midgetspy/Sick-Beard/tarball/development && mv development sickbeard.tar.gz",
	    creates     => "/root/sickbeard.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract sickbeard"],
	    path        => "/usr/bin:/bin",
	    require     => User[$runtime_user];
	"Extract sickbeard":
	    command     => "tar -xf /root/sickbeard.tar.gz && ln -s midgetspy-Sick-Beard-* $home_dir && chown -R $runtime_user midgetspy-Sick-Beard-*",
	    creates     => $home_dir,
	    cwd         => "/usr/share",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    common::define::package {
	"Cheetah":
	    provider => "pip",
	    require  => Class[Common::Tools::Pip];
    }
}
