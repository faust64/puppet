class common::physical::linuxcounter {
    $api_key     = hiera("lico_api_key")
    $machineid   = false
    $update_day  = hiera("lico_update_day")
    $update_hour = hiera("lico_update_hour")
    $update_min  = hiera("lico_update_min")
    $updatekey   = false

    if (! defined(Class[curl])) {
	include curl
    }

    if ($update_day != false and $update_hour != false and $update_min != false) {
	cron {
	    "Update LinuxCounter data":
		command => "/usr/local/bin/lico-update -m >/dev/null 2>&1",
		hour    => $update_hour,
		minute  => $update_min,
		require => File["Install linux-counter update script"],
		weekday => $update_day;
	}
    }

    if ($api_key != false) {
	file {
	    "Prepare LinuxConter for further configuration":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0700",
		owner   => root,
		path    => "/root/.linuxcounter";
	    "Install LinuxConter initial configuration":
		content => template("common/lico.erb"),
		group   => hiera("gid_zero"),
		mode    => "0600",
		owner   => root,
		path    => "/root/.linuxcounter/$hostname",
		replace => no;
	}
#FIXME
#either set proper machine_id and machine_updatekey, or register
    }

    if ($operatingsystem == "FreeBSD" or $operatingsystem == "OpenBSD") {
	file {
	    "Install lsb-release on BSD":
		content => template("common/lsb-release.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/lsb-release";
	}

	File["Install lsb-release on BSD"]
	    -> File["Install linux-counter update script"]
    }

    file {
	"Install linux-counter update script":
	    group  => hiera("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/usr/local/bin/lico-update",
	    source => "puppet:///modules/common/lico-update";
    }
}
