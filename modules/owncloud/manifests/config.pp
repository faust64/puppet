class owncloud::config {
    $domains        = $owncloud::vars::domains
    $db_host        = $owncloud::vars::db_host
    $db_name        = $owncloud::vars::db_name
    $db_pass        = $owncloud::vars::db_pass
    $db_tableprefix = $owncloud::vars::db_tableprefix
    $db_user        = $owncloud::vars::db_user
    $instance_id    = $owncloud::vars::instance_id
    $mail_domain    = $owncloud::vars::mail_domain
    $mail_from      = $owncloud::vars::mail_from
    $password_salt  = $owncloud::vars::password_salt
    $php_apc        = $owncloud::vars::php_apc
    $rewrite_proto  = $owncloud::vars::rewrite_proto
#   $rewrite_root   = $owncloud::vars::rewrite_root
    $secret         = $owncloud::vars::secret
    $theme          = $owncloud::vars::theme
    $version        = $owncloud::vars::version
    $web_root       = $owncloud::vars::web_root

    file {
	"Prepare owncloud for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => $owncloud::vars::runtime_user,
	    path    => "$web_root/config";
	"Install owncloud main configuration":
	    content => template("owncloud/config.erb"),
	    group   => $owncloud::vars::runtime_group,
	    mode    => "0640",
	    owner   => $owncloud::vars::runtime_user,
	    path    => "$web_root/config/config.php",
	    require => File["Prepare owncloud for further configuration"];
    }

    mysysctl::define::setfile {
	"owncloud":
	    source => "owncloud/sysctl.conf";
    }

    if ($owncloud::vars::do_backup) {
	file {
	    "Prepare owncloud backup directory":
		ensure  => directory,
		path    => "/var/backups/owncloud";
	}
    }
}
