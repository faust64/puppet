class subsonic::debian {
    $max_mem      = $subsonic::vars::max_mem
    $listen       = $subsonic::vars::listen_ports
    $runtime_user = "root"

#WARNING:
# subsonic package is distributed by our local repository
    common::define::package {
	[ "subsonic" ]:
    }

    if ($lsbdistcodename == "jessie") {
	apt::define::repo {
	    "debian-multimedia":
		baseurl  => "http://www.deb-multimedia.org/",
		branches => "main non-free",
		codename => "stable";
	}

	exec {
	    "FIXME: install deb-multimedia-keyring":
		command => "apt-get update ; apt-get install -yf --force-yes deb-multimedia-keyring",
		notify  => Exec["Update APT local cache"],
		unless  => "apt-key list | grep deb-multimedia-keyring",
		path    => "/usr/sbin:/sbin:/usr/bin:/bin";
	}

	Apt::Define::Repo["debian-multimedia"]
	    -> Exec["FIXME: install deb-multimedia-keyring"]
	    -> Package["ffmpeg"]
    }

    if ($subsonic::vars::do_flac == true) {
	Package["flac"]
	    -> Package["subsonic"]
    }

    file {
	"Install subsonic service defaults":
	    content => template("subsonic/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["subsonic"],
	    owner   => root,
	    path    => "/etc/default/subsonic",
	    require => Package["subsonic"];
    }

    Package["ffmpeg"]
	-> Package["lame"]
	-> Class["java"]
	-> Package["subsonic"]
	-> File["Install subsonic.properties"]
}
