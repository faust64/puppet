class moin::scripts {
    $lib_dir    = $moin::vars::lib_dir
    $slack_hook = $moin::vars::slack_hook
    $wiki_dir   = "$lib_dir/wiki"

    file {
	"Install MoinMoin site backup script":
	    content => template("moin/backup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/MMbackup",
	    require => Apache::Define::Vhost[$fqdn];
    }
}
