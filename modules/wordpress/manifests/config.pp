class wordpress::config {
    $db_host      = $wordpress::vars::db_host
    $db_name      = $wordpress::vars::db_name
    $db_pass      = $wordpress::vars::db_pass
    $db_user      = $wordpress::vars::db_user
    $conf_dir     = $wordpress::vars::conf_dir
    $kauth        = $wordpress::vars::key_auth
    $ksecure_auth = $wordpress::vars::key_secure_auth
    $klogged_in   = $wordpress::vars::key_logged_in
    $knonce       = $wordpress::vars::key_nonce
    $ksalt        = $wordpress::vars::key_salt
    $ksecure_salt = $wordpress::vars::key_secure_salt
    $proxyname    = $wordpress::vars::proxyname
    $rdomain      = $wordpress::vars::rdomain
    $slogged_in   = $wordpress::vars::salt_logged_in
    $snonce       = $wordpress::vars::salt_nonce
    $usr_dir      = $wordpress::vars::usr_dir
    $var_dir      = $wordpress::vars::lib_dir
    $wp_network   = $wordpress::vars::wp_network

    file {
	"Install wordpress main configuration":
	    content => template("wordpress/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/config-$rdomain.php";
	"Install wordpress main htaccess":
	    content => template("wordpress/htaccess.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$usr_dir/.htaccess",
	    require => File["Install wordpress main configuration"];
	"Link wordpress htaccess to wordress config directory":
	    ensure  => link,
	    force   => true,
	    path    => "$conf_dir/htaccess",
	    require => File["Install wordpress main htaccess"],
	    target  => "$usr_dir/.htaccess";
    }

    if ($domain != $rdomain) {
	file {
	    "Link $domain to $rdomain configuration":
		ensure  => link,
		force   => true,
		path    => "$conf_dir/config-$domain.php",
		require => File["Install wordpress main configuration"],
		target  => "$conf_dir/config-$rdomain.php";
	}
    }
}
