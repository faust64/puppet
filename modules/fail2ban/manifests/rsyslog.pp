class fail2ban::rsyslog {
    $rsyslog_conf_dir = $fail2ban::vars::rsyslog_conf_dir
    $rsyslog_version  = $fail2ban::vars::rsyslog_version

    if (! defined(Class["rsyslog::imfile"])) {
	include rsyslog::imfile
    }

    file {
	"Install Fail2ban rsyslog configuration":
	    content => template("fail2ban/rsyslog.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$fail2ban::vars::rsyslog_service_name],
	    owner   => root,
	    path    => "$rsyslog_conf_dir/rsyslog.d/05_fail2ban.conf",
	    require => Class["rsyslog::imfile"];
    }
}
