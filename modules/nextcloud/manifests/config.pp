class nextcloud::config {
    $domains        = $nextcloud::vars::domains
    $db_host        = $nextcloud::vars::db_host
    $db_name        = $nextcloud::vars::db_name
    $db_pass        = $nextcloud::vars::db_pass
    $db_tableprefix = $nextcloud::vars::db_tableprefix
    $db_user        = $nextcloud::vars::db_user
    $instance_id    = $nextcloud::vars::instance_id
    $mail_domain    = $nextcloud::vars::mail_domain
    $mail_from      = $nextcloud::vars::mail_from
    $password_salt  = $nextcloud::vars::password_salt
    $php_apc        = $nextcloud::vars::php_apc
    $rewrite_proto  = $nextcloud::vars::rewrite_proto
#   $rewrite_root   = $nextcloud::vars::rewrite_root
    $secret         = $nextcloud::vars::secret
    $theme          = $nextcloud::vars::theme
    $version        = $nextcloud::vars::version
    $web_root       = $nextcloud::vars::web_root

    file {
	"Prepare nextcloud for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => $nextcloud::vars::runtime_user,
	    path    => "$web_root/config";
	"Install nextcloud main configuration":
	    content => template("nextcloud/config.erb"),
	    group   => $nextcloud::vars::runtime_group,
	    mode    => "0640",
	    owner   => $nextcloud::vars::runtime_user,
	    path    => "$web_root/config/config.php",
	    require => File["Prepare nextcloud for further configuration"];
    }

    mysysctl::define::setfile {
	"nextcloud":
	    source => "nextcloud/sysctl.conf";
    }

    if ($nextcloud::vars::do_backup) {
	file {
	    "Prepare nextcloud backup directory":
		ensure  => directory,
		path    => "/var/backups/nextcloud";
	}
    }
}
