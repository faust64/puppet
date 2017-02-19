class slim::config {
    $autologin    = $slim::vars::autologin
    $conf_dir     = $slim::vars::conf_dir
    $console_cmd  = $slim::vars::console_cmd
    $login_cmd    = $slim::vars::login_cmd
    $run_dir      = $slim::vars::run_dir
    $runtime_user = $slim::vars::runtime_user
    $server_args  = $slim::vars::server_args
    $suspend_cmd  = $slim::vars::suspend_cmd
    $theme        = $slim::vars::theme
    $window_mgr   = $slim::window_manager
    $xauth        = $slim::vars::xauth
    $xbin         = $slim::vars::xbin

    if ($conf_dir != "/etc" and $conf_dir != "/usr/local/etc") {
	file {
	    "Prepare Slim for further configuration":
		ensure  => directory,
		group   => hiera("gid_zero"),
		mode    => "0755",
		owner   => root,
		path    => $conf_dir;
	}

	File["Prepare Slim for further configuration"]
	    -> File["Install Slim configuration"]
    }

    file {
	"Install Slim configuration":
	    content => template("slim/slim.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/slim.conf";
    }
}
