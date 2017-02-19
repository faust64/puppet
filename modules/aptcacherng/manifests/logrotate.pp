class aptcacherng::logrotate {
    file {
	"Install aptcacherng logrotate configuration":
	    source  => "puppet:///modules/aptcacherng/logrotate.conf",
	    group   => hiera("gid_zero"),
	    owner   => root,
	    path    => "/etc/logrotate.d/apt-cacher-ng",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
