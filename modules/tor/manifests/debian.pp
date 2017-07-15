class tor::debian {
    apt::define::aptkey {
	"tor":
	    keyid => "886DDD89";
    }

    apt::define::repo {
	"tor":
	    baseurl => "http://deb.torproject.org/torproject.org",
	    require => Apt::Define::Aptkey["tor"];
    }

    common::define::package {
	"tor":
	    require => Apt::Define::Repo["tor"];
    }

    file {
	"Install tor service defaults":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["tor"],
	    owner   => root,
	    path    => "/etc/default/tor",
	    require => Package["tor"],
	    source  => "puppet:///modules/tor/defaults";
    }

    Package["tor"]
	-> File["Prepare tor for further configuration"]
}
