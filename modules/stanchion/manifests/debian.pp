class stanchion::debian {
    if (! defined(Apt::Define::Aptkey["packagecloud"])) {
	apt::define::aptkey {
	    "packagecloud":
		url => "https://packagecloud.io/gpg.key";
	}
    }
    if ($operatingsystem == "Ubuntu") {
	$baseurl = "https://packagecloud.io/basho/stanchion/ubuntu"
    } else {
	$baseurl = "https://packagecloud.io/basho/stanchion/debian"
    }
    $db_drive = false

    apt::define::repo {
	"basho_stanchion":
	    baseurl => $baseurl,
	    require => Apt::Define::Aptkey["packagecloud"];
    }

    common::define::package {
	"stanchion":
	    require =>
		[
		    Apt::Define::Repo["basho_riak"],
		    Exec["Update APT local cache"]
		];
    }

    Common::Define::Package["stanchion"]
	-> File["Install Riak limits configuration"]
	-> File["Install Stanchion defaults configuration"]
	-> File["Prepare Stanchion for further configuration"]
	-> Common::Define::Service["stanchion"]

    if (($operatingsystem == "Ubuntu" and $lsbdistcodename == "xenial") or ($operatingsystem == "Debian" and $lsbdistcodename == "jessie")) {
	file {
	    "Prepare Stanchion systemd service configuration":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => "/etc/systemd/system/stanchion.service.d";
	    "Install Stanchion systemd configuration":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		notify  => Exec["Reload systemd configuration"],
		path    => "/etc/systemd/system/stanchion.service.d/limits.conf",
		require => File["Prepare Stanchion systemd service configuration"],
		source  => "puppet:///modules/riak/systemd.conf";
	}

	Exec["Reload systemd configuration"]
	    -> Common::Define::Service["stanchion"]
    }

    file {
	"Install Stanchion defaults configuration":
	    content => template("riak/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["stanchion"],
	    owner   => root,
	    path    => "/etc/default/stanchion";
    }
}
