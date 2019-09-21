class sabnzbd::debian {
    $conf_dir     = $sabnzbd::vars::conf_dir
    $runtime_user = $sabnzbd::vars::runtime_user

    if ($lsbdistcodename == "wheezy") {
	$codename = "precise"
    } elsif ($lsbdistcodename == "jessie") {
	$codename = "precise"
    } elsif ($lsbdistcodename == "stretch") {
	$codename = "xenial"
    } else {
	$codename = $lsbdistcodename
    }

    if ($codename != "buster") {
	apt::define::aptkey {
	    "jcfp":
		keyid     => "4BB9F05F",
		keyserver => "pool.sks-keyservers.net";
	}

	apt::define::repo {
	    "sabnzbd":
		baseurl  => "http://ppa.launchpad.net/jcfp/ppa/ubuntu",
		codename => $codename,
		require  => Apt::Define::Aptkey["jcfp"];
	}

	Apt::Define::Repo["sabnzbd"]
	    -> Common::Define::Package["sabnzbdplus"]
    }

    if ($lsbdistcodename == "stretch") {
	common::define::package {
	    "unrar-free":
	}
    } else {
	common::define::package {
	    "unrar":
	}
    }

    common::define::package {
	[ "sabnzbdplus", "p7zip-full", "par2" ]:
    }

    file {
	"Install sabnzbdplus service defaults":
	    content => template("sabnzbd/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => root,
	    path    => "/etc/default/sabnzbdplus";
    }

    Package["sabnzbdplus"]
	-> File["Install sabnzbdplus service defaults"]
	-> File["Prepare Sabnzbd for further configuration"]
}
