class newznab::config {
    $ldap_object_login = $newznab::vars::ldap_object_login
    $ldap_object_mail  = $newznab::vars::ldap_object_mail
    $ldap_slave        = $newznab::vars::ldap_slave
    $ldap_user_base    = $newznab::vars::ldap_user_base
    $mysql_db          = $newznab::vars::mysql_db
    $mysql_pass        = $newznab::vars::mysql_pass
    $mysql_user        = $newznab::vars::mysql_user
    $nntp_host         = $newznab::vars::nntp_host
    $nntp_pass         = $newznab::vars::nntp_pass
    $nntp_user         = $newznab::vars::nntp_user
    $web_root          = $newznab::vars::web_root
    $with_cache        = $newznab::vars::with_cache

    file {
	"Install Newznab main configuration":
	    content => template("newznab/config.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/nnplus/www/config.php",
	    require => Exec["Drop nnplus install menus"];
    }
}
