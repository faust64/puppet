class rsyslog::collectscripts {
    $contact   = $rsyslog::vars::contact
    $store_dir = $rsyslog::vars::store_dir

    file {
	"Install rsyslog collection purge script":
	    content => template("rsyslog/quota.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/rsyslog_quota";
    }
}
