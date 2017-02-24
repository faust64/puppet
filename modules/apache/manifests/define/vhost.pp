define apache::define::vhost($aliases         = false,
			     $allow_override  = false,
			     $app_port        = 8080,
			     $app_proto       = "http",
			     $app_root        = $apache::vars::web_root,
			     $app_rewrite     = true,
			     $csp_name        = false,
			     $deny_frames     = true,
			     $group_base      = $apache::vars::search_group_base,
			     $konami_location = false,
			     $noerrors        = false,
			     $nosniff         = true,
			     $options         = "Indexes FollowSymLinks MultiViews",
			     $preserve_host   = "On",
			     $pubclear        = false,
			     $proxyto         = false,
			     $server_admin    = $apache::vars::server_admin,
			     $sslproxy        = false,
			     $stricttransport = "max-age=63072000; includeSubdomains; preload",
			     $user_base       = $apache::vars::search_user_base,
			     $vhostldapauth   = "pubonly",
			     $vhostrsyslog    = "default",
			     $vhostsource     = "default",
			     $vhoststatus     = "enabled",
			     $with_reverse    = false,
			     $wsgi_child      = 5,
			     $wsgi_max        = 1000,
			     $wsgi_threads    = 10,
			     $wsgi_umask      = "0007",
			     $xss_protection  = true) {
    $conf_dir         = $apache::vars::conf_dir
    $conf_file        = $apache::vars::conf_file
    $csp_policies     = $apache::vars::csp_policies
    $csp_report       = $apache::vars::csp_report
    $csp_sources      = $apache::vars::csp_sources
    $hpkp_max_age     = $apache::vars::hpkp_max_age
    $hpkp_report      = $apache::vars::hpkp_report
    $ldap_slave       = $apache::vars::ldap_slave
    $log_dir          = $apache::vars::log_dir
    $listen_ports     = $apache::vars::listen_ports
    $rsyslog_conf_dir = $apache::vars::rsyslog_conf_dir
    $rsyslog_version  = $apache::vars::rsyslog_version
    $sendfilepath     = $apache::vars::sendfilepath
    $version          = $apache::vars::version

    if ($listen_ports['ssl'] != false and $version == "2.4") {
	apache::define::certificate_chain {
	    $name:
	}

	if (defined(Pki::Define::Get["$fqdn server certificate"])) {
	    Pki::Define::Get["$fqdn server certificate"]
		-> Pki::Define::Get["PKI web service chain"]
		-> Apache::Define::Certificate_chain[$name]
	}

	File["Install apache ssl generic configuration"]
	    -> File["Apache $name vhost configuration"]
    }

    if (! defined(File["Apache $name vhost configuration"])) {
	file {
	    "Apache $name vhost configuration":
		content      => template("apache/vhost/$vhostsource.erb"),
		group        => hiera("gid_zero"),
		mode         => "0644",
		notify       => Service[$apache::vars::service_name],
		owner        => root,
		path         => "$conf_dir/sites-available/$name.conf";
#Invalid parameter validate_cmd at /etc/puppet/modules/apache/manifests/define/vhost.pp:17
#http://docs.puppetlabs.com/references/latest/type.html#file-attribute-validate_cmd
# a wtf a day, reminds you how hazardous puppet is, ...
#		validate_cmd => "/usr/sbin/apache2 -t -f $conf_dir/$conf_file";
	}

	if ($vhoststatus == "enabled") {
	    file {
		"Enable Apache $name vhost configuration":
		    ensure       => link,
		    force        => true,
		    notify       => Service[$apache::vars::service_name],
		    path         => "$conf_dir/sites-enabled/$name.conf",
		    target       => "$conf_dir/sites-available/$name.conf";
#		    validate_cmd => '/usr/sbin/apache2 -t -f $conf_dir/$conf_file';
	    }

	    if ($vhostrsyslog == true or ($vhostrsyslog == "default" and $apache::vars::apache_rsyslog == true)) {
		file {
		    "Enable Apache rsyslog vhost $name configuration":
			content => template("apache/rsyslog-vhost.erb"),
			group   => hiera("gid_zero"),
			mode    => "0600",
			notify  => Service[$apache::vars::rsyslog_service_name],
			owner   => root,
			path    => "$rsyslog_conf_dir/rsyslog.d/11_apache_vhost_$name.conf",
			require => File["Prepare rsyslog for further configuration"];
		}
	    }

	    if ($with_reverse != false) {
		if ($vhostldapauth != false) { $revauth = false }
		else { $revauth = "pubonly" }
		if ($listen_ports['ssl'] != false) {
		    $port      = inline_template("<% if @listen_ports['ssl'] =~ /:/ -%><%=@listen_ports['ssl'].gsub(/[0-9.]*:/, '')%><% else -%><%=@listen_ports['ssl']%><% end -%>")
		    $proxyaddr = "https://$name:$port"
		    $hasssl    = true
		} else {
		    $port      = inline_template("<% if @listen_ports['plain'] =~ /:/ -%><%=@listen_ports['plain'].gsub(/[0-9.]*:/, '')%><% else -%><%=@listen_ports['plain']%><% end -%>")
		    $proxyaddr = "http://$name:$port"
		    $hasssl    = false
		}

		@@apache::define::vhost {
		    $with_reverse:
			aliases         => $aliases,
			deny_frames     => $deny_frames,
			nosniff         => $nosniff,
			proxyto         => $proxyaddr,
			preserve_host   => $preserve_host,
			pubclear        => $pubclear,
			sslproxy        => $hasssl,
			stricttransport => $stricttransport,
			tag             => "reverse-$domain",
			vhostldapauth   => $revauth,
			vhostrsyslog    => false,
			vhostsource     => "proxy";
		}
	    }
	}
	else {
	    file {
		"Disable Apache $name vhost configuration":
		    ensure  => absent,
		    force   => true,
		    notify  => Service[$apache::vars::service_name];
	    }
	}
    }

    if (defined(Class[Rsyslog]) and
	! defined(File["Enable Apache rsyslog vhost $name configuration"])) {
	file {
	    "Purge Apache rsyslog vhost $name configuration":
		ensure  => absent,
		force   => true,
		notify  => Service[$apache::vars::rsyslog_service_name],
		path    => "$rsyslog_conf_dir/rsyslog.d/11_apache_vhost_$name.conf",
	}
    }
}
