class medusa::config {
    $api_key        = $medusa::vars::api_key
    $cookie_secret  = $medusa::vars::cookie_secret
    $encryption_key = $medusa::vars::encryption_key
    $freq           = $medusa::vars::search_freq
    $home_dir       = $medusa::vars::home_dir
    $providers      = $medusa::vars::providers
    $sab_api_key    = $medusa::vars::sab_api_key
    $sab_host       = $medusa::vars::sab_host
    $slack_hook     = $medusa::vars::slack_hook
    $slack_notify   = $medusa::vars::slack_notify
    $thedate        = Timestamp.new().strftime('%Y-%m-%d')
    $web_dir        = $medusa::vars::web_dir

    file {
	"Install Medusa main configuration":
	    content => template("medusa/config.erb"),
	    group   => $medusa::vars::runtime_group,
	    mode    => "0640",
	    notify  => Common::Define::Service["medusa"],
	    owner   => $medusa::vars::runtime_user,
	    path    => "$home_dir/config.ini",
	    require => Git::Define::Clone["medusa"];
    }
}
