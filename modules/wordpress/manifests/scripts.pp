class wordpress::scripts {
    $download   = $wordpress::vars::download
    $log_dir    = $wordpress::vars::apache_log_dir
    $slack_hook = $wordpress::vars::slack_hook

    exec {
	"Download wp-cli":
	    command     => "$download https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
	    creates     => "/usr/local/bin/wp-cli",
	    cwd         => "/root",
	    notify      => Exec["Install wp-cli"],
	    path        => "/usr/bin:/bin",
	    require     => Class["php"];
	"Install wp-cli":
	    command     => "mv /root/wp-cli.phar wp-cli",
	    cwd         => "/usr/local/bin",
	    refreshonly => true,
	    path        => "/usr/bin:/bin";
    }

    file {
	"Set permissions to wp-cli":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/wp-cli",
	    require => Exec["Install wp-cli"];
	"Install Wordpress backup script":
	    content => template("wordpress/backup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/Wordpressbackup",
	    require => Exec["Install wp-cli"];
    }

    @@file {
	"Install wordpress blacklist update script":
	    content => template("wordpress/update_blacklist.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/wp_update_blacklist",
	    tag     => "reverse-$domain";
    }
}
