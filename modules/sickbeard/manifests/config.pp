class sickbeard::config {
    $api_key      = $sickbeard::vars::api_key
    $conf_dir     = $sickbeard::vars::conf_dir
    $freq         = $sickbeard::vars::search_freq
    $home_dir     = $sickbeard::vars::home_dir
    $providers    = $sickbeard::vars::providers
    $sab_api_key  = $sickbeard::vars::sab_api_key
    $sab_host     = $sickbeard::vars::sab_host
    $slack_notify = $sickbeard::vars::slack_notify
    $web_dir      = $sickbeard::vars::web_dir

    file {
	"Prepare sickbeard for further configuration":
	    ensure   => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => $sickbeard::vars::runtime_user,
	    path    => $conf_dir;
	"Install sickbeard main configuration":
	    content => template("sickbeard/config.erb"),
	    group   => $sickbeard::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["sickbeard"],
	    owner   => $sickbeard::vars::runtime_user,
	    path    => "$conf_dir/config.ini",
	    require =>
		[
		    File["Prepare sickbeard for further configuration"],
		    File["Prepare sickbeard store directory"]
		];
	"Link applicative logs to /var/log":
	    ensure  => link,
	    force   => true,
	    path    => "/var/log/sickbeard",
	    require => Git::Define::Clone["sickbeard"],
	    target  => "$home_dir/Logs";
    }
}
