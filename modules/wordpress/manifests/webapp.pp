class wordpress::webapp {
    include apache
    include mysql

    mysql::define::create_database {
	$wordpress::vars::db_name:
	    dbpass  => $wordpress::vars::db_pass,
	    dbuser  => $wordpress::vars::db_user;
    }

    apache::define::vhost {
	$wordpress::vars::srvname:
	    aliases       => $wordpress::vars::aliases,
	    app_root      => $wordpress::vars::usr_dir,
	    csp_name      => "wordpress",
	    deny_frames   => "remote",
	    vhostldapauth => "applicative",
	    vhostsource   => "wordpress",
	    with_reverse  => $wordpress::vars::proxyname;
    }
}
