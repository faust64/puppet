class sickbeard::install {
    $home_dir = $sickbeard::vars::home_dir

    group {
	$sickbeard::vars::runtime_group:
	   ensure => present;
    }

    user {
	$sickbeard::vars::runtime_user:
	    gid     => $sickbeard::vars::runtime_group,
	    require => Group[$sickbeard::vars::runtime_group];
    }

    git::define::clone {
	"sickbeard":
	    branch          => "development",
	    grp             => $sickbeard::vars::runtime_group,
	    usr             => $sickbeard::vars::runtime_user,
	    local_container => "/usr/share",
	    repository      => "https://github.com/midgetspy/Sick-Beard",
	    require         => User[$runtime_user],
	    update          => false;
    }

    common::define::package {
	"Cheetah":
	    provider => "pip",
	    require  => Class[Common::Tools::Pip];
    }
}
