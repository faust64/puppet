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

	exec {
	    "Download Plex-YouTube.TV plugin":
		command     => "wget https://github.com/kolsys/YouTubeTV.bundle/archive/v$youtubeversion.tar.gz",
		cwd         => "/usr/src",
		unless      => "tar -tzf v$youtubeversion.tar.gz >/dev/null",
		notify      => Exec["Extract Plex-YouTube.TV plugin"],
		path        => "/usr/bin:/bin",
		require     => Package["plexmediaserver"];
	    "Extract Plex-YouTube.TV plugin":
		command     => "rm -fr YouTubeTV.bundle ; tar -xzf /usr/src/v$youtubeversion.tar.gz && mv YouTubeTV.bundle-$youtubeversion YouTubeTV.bundle",
		cwd         => "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-ins",
		notify      => Service["plexmediaserver"],
		path        => "/usr/bin:/bin",
		refreshonly => true;
	}

	file {
	    "Link plex logs to /var/log":
		ensure  => link,
		force   => true,
		path    => "/var/log/plex",
		require => Package["plexmediaserver"],
		target  => "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Logs";
	}
    }

    if ($media::vars::plex != false) {
	common::define::package {
	    "emby-server":
		require =>
		    [
			Apt::Define::Repo["UTGB"],
			Exec["Update APT local cache"]
		    ];
	}
    }
}
