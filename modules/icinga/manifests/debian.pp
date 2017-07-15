class icinga::debian {
    $conf_dir      = $icinga::vars::conf_dir
    $lib_dir       = $icinga::vars::lib_dir
    $runtime_group = $icinga::vars::runtime_group
    $runtime_user  = $icinga::vars::runtime_user
    $web_group     = $icinga::vars::web_group

    if ($lsbdistcodename == "wheezy") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    branches => "main contrib non-free",
		    codename => "wheezy-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Exec["Update APT local cache"]
	    -> Package["check-mk-livestatus"]
	    -> Package["icinga"]
    } elsif ($lsbdistcodename == "jessie") {
	exec {
	    "Setuid ping":
		command => "chmod u+s ping",
		cwd     => "/bin",
		path    => "/usr/bin:/bin",
		unless  => "test `stat -c %a ping` = 4755";
	}
    }

    if ($operatingsystem == "Debian") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    branches => "main contrib non-free",
		    codename => "$lsbdistcodename-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Package["check-mk-livestatus"]
    } elsif ($myoperatingsystem == "Devuan") {
	if (! defined(Apt::Define::Repo["backports"])) {
	    apt::define::repo {
		"backports":
		    baseurl  => "http://auto.mirror.devuan.org/merged",
		    branches => "main contrib non-free",
		    codename => "$lsbdistcodename-backports";
	    }
	}

	Apt::Define::Repo["backports"]
	    -> Package["check-mk-livestatus"]
    }

    common::define::package {
	[ "check-mk-livestatus", "nagios-nrpe-plugin", "icinga", "nagios-images" ]:
    }

    exec {
	"Override Icinga socket group":
	    command => "dpkg-statoverride --update --add --force $runtime_user $web_group 2710 $lib_dir/rw && dpkg-statoverride --update --add --force $runtime_user $runtime_group 751 $lib_dir",
	    cwd     => "/",
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin:",
	    require =>
		[
		    Package["icinga"],
		    Class[Apache]
		],
	    unless  => "test `stat -c %G $lib_dir/rw` = $web_group";
    }

    file {
	"Install Icinga service defaults":
	    content => template("icinga/debian-defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "/etc/default/icinga";
    }

    Exec["Override Icinga socket group"]
	-> File["Install Icinga rw directory"]
	-> File["Set permissions to icinga socket file"]

    Package["nagios-nrpe-plugin"]
	-> Package["icinga"]
	-> File["Install Icinga service defaults"]
	-> File["Install check_nrpe plugin configuration"]
	-> Icinga::Define::Config["icinga.cfg"]

    Package["nagios-images"]
	-> Exec["Download icinga webapp icons"]

    Package["icinga"]
	-> File["Prepare Icinga main configuration directory"]
	-> File["Prepare Icinga cache directory"]
	-> File["Prepare Icinga lib directory"]
	-> File["Prepare Icinga logs directory"]
	-> File["Prepare Icinga run directory"]
}
