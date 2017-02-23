class transmission::scripts {
    $contact       = $transmission::vars::contact
    $runtime_group = $transmission::vars::runtime_group
    $runtime_user  = $transmission::vars::runtime_user
    $slack_hook    = $transmission::vars::slack_hook
    $store_dir     = $transmission::vars::store_dir

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
	"Install transmission import job":
	    content => template("transmission/importjob.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/transmission_import";
    }
}
