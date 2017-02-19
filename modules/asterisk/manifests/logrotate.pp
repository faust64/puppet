class asterisk::logrotate {
    file {
	"Install asterisk logrotate configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/asterisk",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/asterisk/logrotate";
    }
}
