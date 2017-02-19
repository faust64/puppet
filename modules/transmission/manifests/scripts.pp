class transmission::scripts {
    $contact = $transmission::vars::contact

    file {
	"Install transmission unregistered torrents checker":
	    content => template("transmission/check.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/check_unregistered";
	"Install transmission unregistered torrents cleaner":
	    content => template("transmission/purge.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/remove_unregistered";
    }
}
