class postfix::config {
    $conf_dir          = $postfix::vars::conf_dir
    $local_domains     = $postfix::vars::local_domains
    $mail_ip           = $postfix::vars::mail_ip
    $mail_mx           = $postfix::vars::mail_mx
    $masquerade        = $postfix::vars::masquerade
    $myhostname        = $postfix::vars::myhostname
    $postfix_networks  = $postfix::vars::postfix_networks
    $random_source     = $postfix::vars::random_source
    $rbls              = $postfix::vars::rbls
    $routeto           = $postfix::vars::routeto
    $spamassassin_user = $postfix::vars::spamassassin_user

    if ($masquerade) {
	file {
	    "Install Postfix masquerade configuration":
		content => template("postfix/masquerade.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Service["postfix"],
		owner   => root,
		path    => "$conf_dir/masqueradefrom",
		require => File["Prepare postfix for further configuration"];
	}
    }

    if ($local_domains != false) {
	file {
	    "Install postfix transports configuration":
		content => template("postfix/transports.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		notify  => Exec["Refresh transports database"],
		owner   => root,
		path    => "$conf_dir/transport",
		require => File["Prepare postfix for further configuration"];
	}

	exec {
	    "Refresh transports database":
	        command     => "postmap transport",
	        cwd         => $conf_dir,
	        path        => "/usr/sbin:/sbin:/usr/bin:/bin",
		require     => File["Install postfix transports configuration"],
	        refreshonly => true;
	}
    }

    file {
	"Prepare postfix for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install postfix main configuration":
	    content => template("postfix/main.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["postfix"],
	    owner   => root,
	    path    => "$conf_dir/main.cf",
	    require => File["Prepare postfix for further configuration"];
	"Install postfix master configuration":
	    content => template("postfix/master.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["postfix"],
	    owner   => root,
	    path    => "$conf_dir/master.cf",
	    require => File["Prepare postfix for further configuration"];
    }
}
