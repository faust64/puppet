class apt::logrotate {
    file {
	"Install apt logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/apt",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/apt/logrotate-apt";
	"Install aptitude logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/aptitude",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/apt/logrotate-aptitude";
	"Install dpkg logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/dpkg",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/apt/logrotate-dpkg";
	"Install unattended-upgrades logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/unattended-upgrades",
	    require =>
		[
		    File["Prepare Logrotate for further configuration"],
		    Package["unattended-upgrades"]
		],
	    source  => "puppet:///modules/apt/logrotate-unattended-upgrades";
    }
}
