class riakcs::debian {
    if (! defined(Apt::Define::Aptkey["packagecloud"])) {
	apt::define::aptkey {
	    "packagecloud":
		url => "https://packagecloud.io/gpg.key";
	}
    }
    if ($operatingsystem == "Ubuntu") {
	$baseurl = "https://packagecloud.io/basho/riak-cs/ubuntu"
    } else {
	$baseurl = "https://packagecloud.io/basho/riak-cs/debian"
    }
    $db_drive = false

    apt::define::repo {
	"basho_riakcs":
	    baseurl => $baseurl,
	    require => Apt::Define::Aptkey["packagecloud"];
    }

    common::define::package {
	"riak-cs":
	    require =>
		[
		    Apt::Define::Repo["basho_riak"],
		    Exec["Update APT local cache"]
		];
    }

    file {
	"Install RiakCS defaults configuration":
	    content => template("riak/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["riak-cs"],
	    owner   => root,
	    path    => "/etc/default/riak-cs";
    }

    Common::Define::Package["riak-cs"]
	-> File["Install Riak limits configuration"]
	-> File["Install RiakCS defaults configuration"]
	-> File["Prepare RiakCS for further configuration"]
	-> Common::Define::Service["riak-cs"]

    if (($operatingsystem == "Ubuntu" and $lsbdistcodename == "xenial") or ($operatingsystem == "Debian" and $lsbdistcodename == "jessie")) {
	file {
	    "Prepare RiakCS systemd service configuration":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/etc/systemd/system/riak-cs.service.d";
	    "Install Riak systemd configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		notify  => Exec["Reload systemd configuration"],
		path    => "/etc/systemd/system/riak-cs.service.d/limits.conf",
		require => File["Prepare RiakCS systemd service configuration"],
		source  => "puppet:///modules/riak/systemd.conf";
	}

	Exec["Reload systemd configuration"]
	    -> Common::Define::Service["riak-cs"]
    }
}
