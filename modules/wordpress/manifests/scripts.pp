class wordpress::scripts {
    $log_dir    = $wordpress::vars::apache_log_dir
    $slack_hook = $wordpress::vars::slack_hook

    common::define::geturl {
	"wp-cli":
	    prm     => "0755",
	    require => Class["php"],
	    target  => "/usr/local/bin/wp-cli",
	    url     => "https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar",
	    wd      => "/root";
    }

    file {
	"Install Wordpress backup script":
	    content => template("wordpress/backup.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/Wordpressbackup",
	    require => Common::Define::Geturl["wp-cli"];
    }

    @@file {
	"Install wordpress blacklist update script":
	    content => template("wordpress/update_blacklist.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/wp_update_blacklist",
	    tag     => "reverse-$domain";
    }
}
