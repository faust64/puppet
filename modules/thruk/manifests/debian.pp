class thruk::debian {
    $download      = $thruk::vars::download
    $listen_ports  = $thruk::vars::listen_ports
    $repo          = $thruk::vars::repo
    $start_timeout = $thruk::vars::start_timeout

    apt::define::aptkey {
	"thruk":
	    keyid     => "11C53B7F",
	    keyserver => "keys.gnupg.net";
    }

    apt::define::repo {
	"thruk":
	    baseurl => "http://labs.consol.de/repo/stable/debian",
	    require => Apt::Define::Aptkey["thruk"];
    }

    common::define::package {
	"thruk":
	    require => Apt::Define::Repo["thruk"];
    }

    file {
	"Install Thruk service defaults":
	    content => template("thruk/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["thruk"],
	    owner   => root,
	    path    => "/etc/default/thruk";
    }

    Package["thruk"]
	-> File["Install Thruk service defaults"]
	-> File["Prepare Thruk for further configuration"]
}
