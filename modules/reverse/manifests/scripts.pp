class reverse::scripts {
    $admin    = $reverse::vars::serveradmin
    $conf_dir = $reverse::vars::apache_conf_dir
    $ldap     = $reverse::vars::ldap_slave
    $rdomain  = $reverse::vars::root_domain
    $userbase = $reverse::vars::ldap_user

    file {
	"Install reverse vhost creation script":
	    content => template("reverse/new_reverse.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/new_reverse.sh";
    }
}
