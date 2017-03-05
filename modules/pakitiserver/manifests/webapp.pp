class pakitiserver::webapp {
    include apache

    $conf_dir        = $pakitiserver::vars::apache_conf_dir
    $rdomain         = $pakitiserver::vars::rdomain
    $http_passphrase = $pakitiserver::vars::http_passphrase
    $http_user       = $pakitiserver::vars::http_user

    if ($domain != $rdomain) {
	$reverse = "pakiti.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    exec {
	"Install pakiti clients htpasswd":
	    command => "htpasswd -b -c pakiti.htpasswd '$http_user' '$http_passphrase'",
	    cwd     => $conf_dir,
	    path    => "/usr/bin:/bin",
	    require => File["Prepare Apache for further configuration"],
	    unless  => "test -s pakiti.htpasswd";
    }

    file {
	"Set pakiti clients htpasswd permissions":
	    group   => $pakitiserver::vars::apache_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/pakiti.htpasswd",
	    require => Exec["Install pakiti clients htpasswd"];
    }

    mysql::define::create_database {
	"pakiti2":
	    dbpass   => $pakitiserver::vars::db_passphrase,
	    dbuser   => $pakitiserver::vars::db_user,
	    require  => Exec["Generate Pakiti database initial import"],
	    withinit => "/root/init.sql";
    }

    apache::define::vhost {
	"pakiti.$domain":
	    aliases       => $aliases,
	    app_root      => "/usr/share/pakiti/www",
	    vhostldapauth => true,
	    vhostsource   => "pakiti",
	    with_reverse  => $reverse;
    }
}
