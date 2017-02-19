class racktables::webapp {
    $auth_backend = $racktables::vars::auth_backend
    $conf_dir     = $racktables::vars::conf_dir
    $db_pass      = $racktables::vars::db_pass
    $db_user      = $racktables::vars::db_user
    $rdomain      = $racktables::vars::rdomain
    $ldap_slave   = $racktables::vars::ldap_slave
    $ldap_suffix  = $racktables::vars::ldap_suffix
    $web_root     = $racktables::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "racktables.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    mysql::define::create_database {
	"racktables":
	    dbpass => $db_pass,
	    dbuser => $db_user;
    }

    apache::define::vhost {
	"racktables.$domain":
	    aliases       => $aliases,
	    app_root      => "$web_root/racktables",
	    csp_name      => "racktables",
	    vhostldapauth => true,
	    with_reverse  => $reverse;
    }

    file {
	"Install racktables secret.php":
	    content => template("racktables/secret.erb"),
	    group   => $racktables::vars::wwwgroup,
	    mode    => "0640",
	    owner   => root,
	    path    => "$web_root/racktables/inc/secret.php",
	    require => Exec["Install racktables wwwroot"];
	"Install racktables dictionnary patch":
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    owner   => root,
	    path    => "/root/patch_dictionary.sql",
	    require => Exec["Install racktables wwwroot"],
	    source  => "puppet:///modules/racktables/patch_dictionary.sql";
    }

    racktables::define::set_enterprise {
	"UTGB":
    }

    each($racktables::vars::munin_host) |$host| {
	racktables::define::set_munin {
	    $host:
	}
    }
}
