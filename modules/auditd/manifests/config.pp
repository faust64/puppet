class auditd::config {
    $buf_size    = $auditd::vars::buffer_size
    $conf_dir    = $auditd::vars::conf_dir
    $contact     = $auditd::vars::contact
    $gid_zero    = hiera("gid_zero")
    $keep        = $auditd::vars::keep
    $logfilesize = $auditd::vars::max_logfile_size
    $plugins_dir = $auditd::vars::plugins_conf_dir

    file {
	"Prepare auditd for further configuration":
	    ensure  => directory,
	    group   => $gid_zero,
	    mode    => "0750",
	    owner   => root,
	    path    => $conf_dir;
	"Install auditd rules configuration":
	    content => template("auditd/rules.erb"),
	    group   => $gid_zero,
	    mode    => "0640",
	    notify  => Service["auditd"],
	    owner   => root,
	    path    => "$conf_dir/audit.rules",
	    require => File["Prepare auditd for further configuration"];
	"Install auditd main configuration":
	    content => template("auditd/config.erb"),
	    group   => $gid_zero,
	    mode    => "0640",
	    notify  => Service["auditd"],
	    owner   => root,
	    path    => "$conf_dir/audit.conf",
	    require => File["Prepare auditd for further configuration"];

	"Prepare auditd plugins configuration directory":
	    ensure  => directory,
	    group   => $gid_zero,
	    mode    => "0750",
	    owner   => root,
	    path    => $plugins_dir,
	    require => File["Prepare auditd for further configuration"];
	"Prepare auditd included plugins configuration directory":
	    ensure  => directory,
	    group   => $gid_zero,
	    mode    => "0750",
	    owner   => root,
	    path    => "$plugins_dir/plugins.d",
	    require => File["Prepare auditd plugins configuration directory"];
	"Install auditd plugins main configuration":
	    content => template("auditd/conf-plugins.erb"),
	    group   => $gid_zero,
	    mode    => "0640",
	    notify  => Service["auditd"],
	    owner   => root,
	    path    => "$plugins_dir/audispd.conf",
	    require => File["Prepare auditd included plugins configuration directory"];
    }
}
