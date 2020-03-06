class media::debian {
    common::define::package {
	"mkvtoolnix":
    }

    if ($media::vars::plex != false) {
	common::define::package {
	    "plexmediaserver":
		require =>
		    [
			Apt::Define::Repo["UTGB"],
			Exec["Update APT local cache"]
		    ];
	}

	$youtubeversion = "4.4"

	common::define::geturl {
	    "Plex-YouTube.TV plugin":
		nomv    => true,
		notify  => Exec["Extract Plex-YouTube.TV plugin"],
		require => Common::Define::Package["plexmediaserver"],
		target  => "/usr/src/v$youtubeversion.tar.gz",
		url     => "https://github.com/kolsys/YouTubeTV.bundle/archive/v$youtubeversion.tar.gz",
		wd      => "/usr/src";
	}

	exec {
	    "Extract Plex-YouTube.TV plugin":
		command     => "rm -fr YouTubeTV.bundle ; tar -xzf /usr/src/v$youtubeversion.tar.gz && mv YouTubeTV.bundle-$youtubeversion YouTubeTV.bundle",
		cwd         => "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins",
		notify      => Common::Define::Service["plexmediaserver"],
		path        => "/usr/bin:/bin",
		refreshonly => true;
	}

	file {
	    "Link plex logs to /var/log":
		ensure  => link,
		force   => true,
		path    => "/var/log/plex",
		require => Common::Define::Package["plexmediaserver"],
		target  => "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs";
	}
    }

    if ($media::vars::emby != false) {
	common::define::package {
	    "emby-server":
		require =>
		    [
			Apt::Define::Repo["UTGB"],
			Exec["Update APT local cache"]
		    ];
	}

	file {
	    "Link emby logs to /var/log":
		ensure  => link,
		force   => true,
		path    => "/var/log/emby",
		require => Common::Define::Package["emby-server"],
		target  => "/var/lib/emby/logs";
	}
    }
}
