class spamassassin::rsyslog {
    include rsyslog::imfile

    $conf_dir = $spamassassin::vars::rsyslog_conf_dir
    $version  = $spamassassin::vars::rsyslog_version

    file {
	"Install spamassassin rsyslog main configuration":
	    content => template("spamassassin/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0600",
	    notify  => Service[$spamassassin::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$conf_dir/rsyslog.d/04_spamassassin.conf",
	    require => File["Prepare rsyslog for further configuration"];
    }
}
