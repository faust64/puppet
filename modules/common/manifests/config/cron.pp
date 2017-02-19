class common::config::cron {
    $allowed_users = hiera("cron_allowed_users")
    $cron_srvname  = hiera("cron_service_name")

    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	Package {
	    "cron":
	}

	Package["cron"]
	    -> File["Restrict access to crontab"]
    } elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	Package {
	    "cronie":
	}

	Package["cronie"]
	    -> File["Restrict access to crontab"]
    } elsif ($operatingsystem == "FreeBSD") {
	common::define::lined {
	    "Enable cron service":
		line   => 'cron_enable="YES"',
		match  => '^cron_enable=',
		notify => Service[$cron_srvname],
		path   => "/etc/rc.conf";
	}
    }

    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu"
	or $operatingsystem == "CentOS" or $operatingsystem == "RedHat"
	or $operatingsystem == "FreeBSD") {
	file {
	    "Restrict access to crontab":
		ensure => present,
		group  => hiera("gid_zero"),
		mode   => "0400",
		owner  => root,
		path   => "/etc/crontab";
	}
    }
    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu"
	or $operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
	file {
	    "Set proper permissions to cron.d":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/cron.d";
	    "Set proper permissions to cron.daily":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/cron.daily";
	    "Set proper permissions to cron.hourly":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/cron.hourly";
	    "Set proper permissions to cron.monthly":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/cron.monthly";
	    "Set proper permissions to cron.weekly":
		ensure => directory,
		group  => hiera("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => "/etc/cron.weekly";
	}
    }

    file {
	"Install cron allowed users list":
	    content => template("common/job-allow.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0400",
	    owner   => root,
	    path    => hiera("cron_allow");
	"Ensure cron denied users list absent":
	    ensure  => absent,
	    force   => true,
	    path    => hiera("cron_deny");
	"Install at allowed users list":
	    content => template("common/job-allow.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0400",
	    owner   => root,
	    path    => hiera("at_allow");
	"Ensure at denied users list absent":
	    ensure  => absent,
	    force   => true,
	    path    => hiera("at_deny");
    }

    common::define::service {
	$cron_srvname:
	    ensure => running;
    }
}
