class sickbeard::install {
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

    common::define::geturl {
	"sickbeard":
	    notify  => Exec["Extract sickbeard"],
	    require => User[$runtime_user],
	    target  => "/root/sickbeard.tar.gz",
	    url     => "https://github.com/midgetspy/Sick-Beard/tarball/development",
	    wd      => "/root";
    }

    exec {
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
