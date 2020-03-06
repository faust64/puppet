class riak::debian {
    $db_drive = $riak::vars::db_drive

    if ($riak::vars::enterprise) {
	common::define::package {
	    "riak-ee":
		require => Apt::Define::Repo["UTGB"];
	}

	if (($operatingsystem == "Ubuntu" and $lsbdistcodename == "xenial") or ($operatingsystem == "Debian" and $lsbdistcodename == "jessie")) {
	    Package["riak-ee"]
		-> File["Prepare Riak systemd service configuration"]
	}

	Package["riak-ee"]
	    -> File["Install Riak defaults configuration"]
	    -> File["Prepare riak for further configuration"]
    } else {
	if (! defined(Apt::Define::Aptkey["packagecloud"])) {
	    apt::define::aptkey {
		"packagecloud":
		    url => "https://packagecloud.io/gpg.key";
	    }
	}

	if ($operatingsystem == "Ubuntu") {
	    $baseurl = "https://packagecloud.io/basho/riak/ubuntu"
	} else {
	    $baseurl = "https://packagecloud.io/basho/riak/debian"
	}

	apt::define::repo {
	    "basho_riak":
		baseurl => $baseurl,
		require => Apt::Define::Aptkey["packagecloud"];
	}

	common::define::package {
	    "riak":
		require =>
		    [
			Apt::Define::Repo["basho_riak"],
			Exec["Update APT local cache"]
		    ];
	}

	if ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty") {
	    Package["riak"]
		-> File["Drop riak upstart dummy configuration"]
	}

	Package["riak"]
	    -> File["Install Riak defaults configuration"]
	    -> File["Prepare riak for further configuration"]
    }

    if (($operatingsystem == "Ubuntu" and $lsbdistcodename == "xenial") or ($operatingsystem == "Debian" and $lsbdistcodename == "jessie")) {
	file {
	    "Prepare Riak systemd service configuration":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/etc/systemd/system/riak.service.d";
	    "Install Riak systemd configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		notify  => Exec["Reload systemd configuration"],
		path    => "/etc/systemd/system/riak.service.d/limits.conf",
		require => File["Prepare Riak systemd service configuration"],
		source  => "puppet:///modules/riak/systemd.conf";
	}

	Exec["Reload systemd configuration"]
	    -> Common::Define::Service["riak"]
    } elsif ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty") {
	file {
	    "Drop riak upstart dummy configuration":
		ensure => absent,
		force  => true,
		notify => Service["riak"],
		path   => "/etc/init/riak.conf";
	}
    }

    file {
	"Install Riak defaults configuration":
	    content => template("riak/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["riak"],
	    owner   => root,
	    path    => "/etc/default/riak";
    }

    each([ "root", $riak::vars::runtime_user ]) |$username| {
	each([ "soft", "hard" ]) |$limit| {
	    common::define::lined {
		"Set Riak $username $limit limits":
		    line => "$username $limit nofile 65536",
		    path => "/etc/security/limits.conf";
	    }

	    Common::Define::Lined["Set Riak $username $limit limits"]
		-> Common::Define::Service["riak"]
	}
    }
}
