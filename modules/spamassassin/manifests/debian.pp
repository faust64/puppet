class spamassassin::debian {
    common::define::package {
	"spamassassin":
    }

    file {
	"Install spamassassin service defaults":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["spamassassin"],
	    owner   => root,
	    path    => "/etc/default/spamassassin",
	    require => Package["spamassassin"],
	    source  => "puppet:///modules/spamassassin/defaults";
    }

    Package["spamassassin"]
	-> File["Prepare spamassassin for further configuration"]
}
