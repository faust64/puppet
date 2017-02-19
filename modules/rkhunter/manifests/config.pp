class rkhunter::config {
    $apps        = $rkhunter::vars::apps
    $conf_dir    = $rkhunter::vars::conf_dir
    $contact     = $rkhunter::vars::contact
    $db_dir      = $rkhunter::vars::db_dir
    $devfile     = $rkhunter::vars::devfile
    $disabled    = $rkhunter::vars::disabled
    $enabled     = $rkhunter::vars::enabled
    $install_dir = $rkhunter::vars::install_dir
    $has_lwp     = $rkhunter::vars::has_lwp
    $hiddenfile  = $rkhunter::vars::hiddenfile
    $hiddendir   = $rkhunter::vars::hiddendir
    $log_dir     = $rkhunter::vars::log_dir
    $procdel     = $rkhunter::vars::procdel
    $proclisten  = $rkhunter::vars::proclisten
    $pwdless     = $rkhunter::vars::pwdless
    $script_dir  = $rkhunter::vars::script_dir
    $scan_temp   = $rkhunter::vars::scan_temp
    $tmp_dir     = $rkhunter::vars::tmp_dir
    $whitelisted = $rkhunter::vars::whitelisted

    if ($conf_dir != "/etc") {
	file {
	    "Prepare rkhunter for further configuration":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => $conf_dir;
	}

	File["Prepare rkhunter for further configuration"]
	    -> File["Install rkhunter main configuration"]
    }

    file {
	"Install rkhunter main configuration":
	    content => template("rkhunter/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/rkhunter.conf",
    }

    exec {
	"Update rkhunter":
	    command     => "rkhunter --update || echo updated",
	    cwd         => "/",
	    notify      => Exec["Init rkhunter database"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Install rkhunter main configuration"];
	"Init rkhunter database":
	    command     => "rkhunter --update || echo updated",
	    cwd         => "/",
	    path        => "/usr/bin:/bin",
	    require     => Exec["Update rkhunter"],
	    refreshonly => true;
    }

    if ($log_dir != "/var/log") {
	file {
	    "Prepare rkhunter log directory":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0750",
		owner   => root,
		path    => $log_dir;
	}

	File["Prepare rkhunter log directory"]
	    -> File["Install rkhunter main configuration"]
    }
}
