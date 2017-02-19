class peerio::logrotate {
    $gidadm   = $peerio::vars::gidadm
    $rotate   = $peerio::vars::rotate
    $logs_dir = $peerio::vars::logs_dir

    file {
	"Install peerio logrotate configuration":
	    content => template("peerio/logrotate.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/pm2.conf",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
