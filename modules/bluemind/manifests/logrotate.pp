class bluemind::logrotate {
    file {
	"Install bm-webmail logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/bm-webmail",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/bluemind/logrotate";
    }
}
