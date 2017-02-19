class sabnzbd::config {
    $api_key       = $sabnzbd::vars::api_key
    $contact       = $sabnzbd::vars::contact
    $conf_dir      = $sabnzbd::vars::conf_dir
    $mail_host     = $sabnzbd::vars::mail_host
    $nntp_host     = $sabnzbd::vars::nntp_host
    $nntp_max_conn = $sabnzbd::vars::nntp_max_conn
    $nntp_pass     = $sabnzbd::vars::nntp_pass
    $nntp_port     = $sabnzbd::vars::nntp_port
    $nntp_timeout  = $sabnzbd::vars::nntp_timeout
    $nntp_user     = $sabnzbd::vars::nntp_user
    $nzb_key       = $sabnzbd::vars::nzb_key
    $password      = $sabnzbd::vars::password
    $username      = $sabnzbd::vars::username
    $rss_source    = $sabnzbd::vars::rss_source

    group {
	$sabnzbd::vars::runtime_group:
	   ensure => present;
    }

    user {
	$sabnzbd::vars::runtime_user:
	    gid     => $sabnzbd::vars::runtime_group,
	    require => Group[$sabnzbd::vars::runtime_group];
    }

    file {
	"Prepare Sabnzbd for further configuration":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => $conf_dir,
	    require => User[$sabnzbd::vars::runtime_user];
	"Prepare Sabnzbd admin directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/admin",
	    require => File["Prepare Sabnzbd for further configuration"];
	"Prepare Sabnzbd cache directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/cache",
	    require => File["Prepare Sabnzbd for further configuration"];
	"Prepare Sabnzbd bin directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/bin",
	    require => File["Prepare Sabnzbd for further configuration"];
	"Prepare Sabnzbd logs directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/logs",
	    require => File["Prepare Sabnzbd for further configuration"];
	"Link Sabnzbd logs to /var/log":
	    ensure  => link,
	    force   => true,
	    target  => "$conf_dir/logs",
	    path    => "/var/log/sabnzbd",
	    require => File["Prepare Sabnzbd logs directory"];
	"Prepare Sabnzbd downloads root directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/downloads",
	    require => File["Prepare Sabnzbd for further configuration"];
	"Prepare Sabnzbd downloads completed directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0775",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/downloads/complete",
	    require => File["Prepare Sabnzbd downloads root directory"];
	"Prepare Sabnzbd downloads pending directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/downloads/incomplete",
	    require => File["Prepare Sabnzbd downloads root directory"];
	"Prepare Sabnzbd downloads queue directory":
	    ensure  => directory,
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/downloads/queue",
	    require => File["Prepare Sabnzbd downloads root directory"];
	"Install skel downloads link":
	    ensure  => link,
	    force   => true,
	    path    => "/etc/skel/SAB-Downloads",
	    require => File["Prepare Sabnzbd downloads completed directory"],
	    target  => "$conf_dir/downloads/complete";
	"Install Sabnzbd main configuration":
	    content => template("sabnzbd/config.erb"),
	    group   => $sabnzbd::vars::runtime_group,
	    mode    => "0600",
	    notify  => Service[$sabnzbd::vars::service_name],
	    owner   => $sabnzbd::vars::runtime_user,
	    path    => "$conf_dir/config.ini",
	    require => File["Prepare Sabnzbd for further configuration"];
    }
}
