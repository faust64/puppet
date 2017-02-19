class rsyslog::debian {
    if ($rsyslog::vars::store_esearch and $lsbdistcodename == "trusty") {
	if (! defined(Apt::Define::Repo["adiscon"])) {
	    apt::define::repo {
		"adiscon":
		    baseurl  => "http://ppa.launchpad.net/adiscon/v8-stable/ubuntu";
	    }
	}

	Apt::Define::Repo["adiscon"]
	    -> Exec["Update APT local cache"]
	    -> Package["rsyslog-elasticsearch"]
    } elsif ($rsyslog::vars::store_esearch and $lsbdistcodename == "wheezy") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    branches => "main contrib non-free",
		    codename => "wheezy-backports";
	    }
	}

	apt::define::pin {
	    [ "libestr0", "rsyslog" ]:
		pinvalue   => 910,
		require    => Apt::Define::Repo["backports"],
		sourceattr => "a=wheezy-backports";
	}

	Apt::Define::Repo["backports"]
	    -> Apt::Define::Pin["libestr0"]
	    -> Apt::Define::Pin["rsyslog"]
	    -> Exec["Update APT local cache"]
	    -> Package["rsyslog"]

	$status = "latest"
    } else {
	$status = "present"
    }

    common::define::package {
	"rsyslog":
	    ensure => $status;
    }

    if ($rsyslog::vars::store_esearch) {
	common::define::package {
	    "rsyslog-elasticsearch":
	}
    }
    if ($rsyslog::vars::do_relp) {
	common::define::package {
	    "rsyslog-relp":
	}
    }

    if ($operatingsystem == "Ubuntu") {
	file {
	    "Drop default ufw configuration":
		ensure  => absent,
		notify  => Service["rsyslog"],
		require => Package["rsyslog"],
		path    => "/etc/rsyslog.d/20-ufw.conf";
	}
    }
}
