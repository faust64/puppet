class newznab::webapp {
    $rdomain  = $newznab::vars::rdomain
    $web_root = $newznab::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "nzbindex.$rdomain"
	$aliases = [ $reverse, "nzbindex.$domain" ]
    } else {
	$reverse = false
	$aliases = false
    }

    if (! defined(Class["apache"])) {
	include apache
    }
    if (! defined(Class["mysql"])) {
	include mysql
    }
    if ($newznab::vars::with_cache == "127.0.0.1"
	or $newznab::vars::with_cache == "localhost"
	or $newznab::vars::with_cache == $ipaddress
	or $newznab::vars::with_cache == $fqdn) {
	include memcache
    }

    mysql::define::create_database {
	$newznab::vars::mysql_db:
	    dbpass   => $newznab::vars::mysql_pass,
	    dbuser   => $newznab::vars::mysql_user,
	    require  => File["Install Newznab main configuration"],
	    withinit => "$web_root/nnplus/db/schema.sql";
    }

    apache::define::vhost {
	"nzbindex.$domain":
	    aliases        => $aliases,
	    allow_override => "All",
	    app_root       => "$web_root/nnplus/www",
	    options        => "FollowSymLinks",
	    require        => Mysql::Define::Create_database[$newznab::vars::mysql_db],
	    vhostldapauth  => "applicative",
	    with_reverse   => $reverse;
    }
}
