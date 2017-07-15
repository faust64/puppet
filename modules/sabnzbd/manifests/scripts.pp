class sabnzbd::scripts {
    $conf_dir   = $sabnzbd::vars::conf_dir
    $run_group  = $sabnzbd::vars::runtime_group
    $run_user   = $sabnzbd::vars::runtime_user
    $pp_hook    = $sabnzbd::vars::download_hook
    $slack_hook = $sabnzbd::vars::slack_hook

    file {
	"Install applicative backup script":
	    content => template("sabnzbd/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/SABbackup";
	"Install post-process-all script":
	    content => template("sabnzbd/post_process.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/bin/post_process_all",
	    require => File["Prepare Sabnzbd bin directory"];
    }
}
