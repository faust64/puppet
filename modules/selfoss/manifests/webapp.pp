class selfoss::webapp {
    $rdomain  = $selfoss::vars::rdomain
    $web_root = $selfoss::vars::web_root

    $aliases  = [ "rss.$domain", "rss.$rdomain", "reader.$domain", "reader.$rdomain", "selfoss.$rdomain" ]

    if (! defined(Class[Apache])) {
	include apache
    }
    if ($selfoss::vars::db_backend == "mysql") {
	if (! defined(Class[Mysql])) {
	    include mysql
	}

	mysql::define::create_database {
	    "selfoss":
		dbpass  => $selfoss::vars::db_pass,
		dbuser  => $selfoss::vars::db_user,
		require =>
		    [
			Class[Mysql],
			Exec["Extract selfoss server root"]
		    ];
	}
    } elsif ($selfoss::vars::db_backend == "sqlite") {
	if (! defined(Class[Sqlite])) {
	    include sqlite
	}
    }

    apache::define::vhost {
	"selfoss.$domain":
	    aliases        => $aliases,
	    allow_override => "all",
	    app_root       => "$web_root/selfoss",
	    vhostldapauth  => false,
	    with_reverse   => "selfoss.$rdomain";
    }
}
