class spamassassin::logrotate {
    file {
	"Install spamassassin logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/spamassassin",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/spamassassin/logrotate";
    }
}
