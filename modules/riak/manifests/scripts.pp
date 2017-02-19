class riak::scripts {
    $backend       = $riak::vars::backend
    $backup_root   = $riak::vars::backup_root
    $backup_target = $riak::vars::backup_target
    $backup_user   = $riak::vars::backup_user
    $contact       = $riak::vars::contact
    $lv            = $riak::vars::lv
    $slack_hook    = $riak::vars::slack_hook
    $snap_size     = $riak::vars::backup_snap_size
    $ssh_port      = $riak::vars::backup_ssh_port
    $vg            = $riak::vars::vg

    file {
	"Install Riak backup script":
	    content => template("riak/backup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/riak_backup";
	"Install Riak service hack script":
	    content => template("riak/hack.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/riak_hack";
	"Install Riak join script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/riak_join_hack",
	    source  => "puppet:///modules/riak/join-hack";
	"Install Riak commit script":
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/riak_commit_hack",
	    source  => "puppet:///modules/riak/commit-hack";
    }

    if ($backup_target) {
	ssh::define::get_hostkey {
	    $backup_target:
		port => $ssh_port;
	}

	if ($riak::vars::backup_hour and $riak::vars::backup_minute) {
	    Ssh::Define::Get_hostkey[$backup_target]
		-> Cron["Backup Riak database"]
	}
    }

    if ($riak::vars::backup_hour and $riak::vars::backup_minute) {
	cron {
	    "Backup Riak database":
		command => "/usr/local/sbin/riak_backup >/dev/null 2>&1",
		hour    => $riak::vars::backup_hour,
		minute  => $riak::vars::backup_minute,
		require => File["Install Riak backup script"],
		user    => root;
	}
    }
}
