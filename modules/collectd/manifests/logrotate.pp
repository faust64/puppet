class collectd::logrotate {
    file {
	"Install collectd logrotate configuration":
	    content => template("collectd/logrotate.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/collectd",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
