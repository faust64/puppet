class sonarr::debian {
    $runtime_group = $sonarr::vars::runtime_group
    $runtime_user  = $sonarr::vars::runtime_user

    apt::define::aptkey {
	"nzbdrone":
	    keyid => "FDA5DFFC";
    }

    apt::define::repo {
	"nzbdrone":
	    baseurl  => "http://apt.sonarr.tv/",
	    codename => "master",
	    require  => Apt::Define::Aptkey["nzbdrone"];
    }

    common::define::package {
	"nzbdrone":
	    notify  => Exec["Fix Sonarr Permissions"],
	    require =>
		[
		    Apt::Define::Repo["nzbdrone"],
		    Exec["Update APT local cache"],
		    Common::Define::Package["mono-devel"]
		];
    }

    file {
	"Install service script":
	    content => template("sonarr/systemd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  =>
		[
		    Exec["Reload systemd configuration"],
		    Common::Define::Service["sonarr"]
		],
	    owner   => "root",
	    path    => "/lib/systemd/system/sonarr.service";
    }

    exec {
	"Fix Sonarr Permissions":
	    command     => "chown -R $runtime_user /opt/NzbDrone",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    File["Ensure Sonarr has an empty home"]
	-> Common::Define::Package["nzbdrone"]
	-> Exec["Fix Sonarr Permissions"]
	-> File["Install service script"]
	-> Common::Define::Service["sonarr"]
}
