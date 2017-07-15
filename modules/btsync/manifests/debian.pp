class btsync::debian {
    $listen_addr = $btsync::vars::listen_addr

    apt::define::aptkey {
	"yeasoft":
	    url => "http://debian.yeasoft.net/btsync.key";
    }

    apt::define::repo {
	"btsync":
	    baseurl => "http://debian.yeasoft.net/btsync",
	    require => Apt::Define::Aptkey["yeasoft"];
    }

    common::define::package {
	"btsync":
	    require =>
		[
		    Apt::Define::Repo["btsync"],
		    Exec["Update APT local cache"]
		];
	"bind-shim":
    }

    file {
	"Install service defaults":
	    content => template("btsync/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    notify  => Service["btsync"],
	    path    => "/etc/default/btsync",
	    require => Package["btsync"];
    }
}
