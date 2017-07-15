class owncloud::webapp {
    include apache

    if ($owncloud::vars::db_backend == "mysql") {
	include mysql

	mysql::define::create_database {
	    $owncloud::vars::db_name:
		dbpass => $owncloud::vars::db_pass,
		dbuser => $owncloud::vars::db_user;
	}
    }

    $domains  = $owncloud::vars::domains
    $rdomain  = $owncloud::vars::rdomain

    if ($domain != $rdomain) {
	$reverse = "owncloud.$rdomain"
	$arraydom = inline_template("<% @domains.values.each do |dom| -%><%=dom%>,<% end -%><%=@reverse%>")
	$aliases  = split($arraydom, ',')
    } else {
	$reverse = false
	$aliases = false
    }

    if ($apache::vars::version == "2.2") {
	$options  = "-Indexes"
	$override = false
    } else {
	$options  = "Indexes FollowSymLinks"
	$override = "All"
    }

    apache::define::vhost {
	"owncloud.$domain":
	    aliases        => $aliases,
	    allow_override => $override,
	    app_root       => $owncloud::vars::web_root,
	    csp_name       => "owncloud",
	    deny_frames    => "remote",
	    options        => $options,
	    require        => File["Prepare owncloud for further configuration"],
	    vhostldapauth  => "applicative",
	    with_reverse   => $reverse;
    }
}
