class subsonic::rhel {
    $max_mem      = $subsonic::vars::max_mem
    $listen       = $subsonic::vars::listen_ports
    $runtime_user = "root"

#WARNING:
# subsonic package is distributed by our local repository
    common::define::package {
	[ "subsonic" ]:
    }

    if ($subsonic::vars::do_flac == true) {
	Package["flac"]
	    -> Package["subsonic"]
    }

    file {
	"Install subsonic service defaults":
	    content => template("subsonic/defaults.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["subsonic"],
	    owner   => root,
	    path    => "/etc/sysconfig/subsonic",
	    require => Package["subsonic"];
    }

    Package["ffmpeg"]
	-> Package["lame"]
	-> Class["java"]
	-> Package["subsonic"]
	-> File["Install subsonic.properties"]
}
