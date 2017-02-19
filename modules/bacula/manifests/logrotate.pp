class bacula::logrotate {
    $work_dir = $bacula::vars::work_dir

    file {
	"Install bacula logrotate configuration":
	    content => template("bacula/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/bacula-common",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
