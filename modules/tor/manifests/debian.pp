class tor::debian {
    apt::define::aptkey {
	"tor":
	    keyid => "886DDD89";
    }

    common::define::package {
	"tor":
	    require => Apt::Define::Aptkey["tor"]
    }

    file {
	"Install tor service defaults":
	    group   => hiera("gid_zero"),
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
