class nextcloud::webapp {
    include apache

    if ($nextcloud::vars::db_backend == "mysql") {
	include mysql

	mysql::define::create_database {
	    $nextcloud::vars::db_name:
		dbpass => $nextcloud::vars::db_pass,
		dbuser => $nextcloud::vars::db_user;
	}
    }

    $domains  = $nextcloud::vars::domains
    $rdomain  = $nextcloud::vars::rdomain

    if ($domain != $rdomain) {
	$reverse = "nextcloud.$rdomain"
	$arraydom = inline_template("<% @domains.values.each do |dom| -%><%=dom%>,<% end -%><%=@reverse%>,cloud.<%=@rdomain%>")
	$aliases  = split($arraydom, ',')
    } else {
	$reverse = false
	$aliases = [ "cloud.$rdomain" ]
    }

    if ($apache::vars::version == "2.2") {
	$options  = "-Indexes"
	$override = false
    } else {
	$options  = "Indexes FollowSymLinks"
	$override = "All"
    }

    apache::define::vhost {
	"nextcloud.$domain":
	    aliases        => $aliases,
	    allow_override => $override,
	    app_root       => $nextcloud::vars::web_root,
	    csp_name       => "nextcloud",
	    deny_frames    => "remote",
	    options        => $options,
	    require        => File["Prepare nextcloud for further configuration"],
	    vhostldapauth  => "applicative",
	    with_reverse   => $reverse;
    }
}
