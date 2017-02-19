define nginx::define::vhost($aliases         = false,
			    $app_port        = 8080,
			    $app_proto       = "http",
			    $app_root        = $nginx::vars::web_root,
			    $app_rewrite     = true,
			    $autoindex       = false,
			    $csp_name        = false,
			    $deny_frames     = true,
			    $fpm_runtime_grp = hiera("apache_runtime_group"),
			    $fpm_runtime_usr = hiera("apache_runtime_user"),
			    $konami_location = false,
			    $noerrors        = false,
			    $nohttpsrewrite  = false,
			    $nosniff         = true,
			    $preserve_host   = "On",
			    $proxyto         = false,
			    $pubclear        = false,
			    $sslproxy        = false,
			    $stricttransport = "max-age=63072000; includeSubdomains; preload",
			    $vhostldapauth   = "pubonly",
			    $vhostrsyslog    = "default",
			    $vhostsource     = "default",
			    $vhoststatus     = "enabled",
			    $with_php_fpm    = false,
			    $with_reverse    = false,
			    $xss_protection  = true) {
    $cgi_socket       = $nginx::vars::cgi_socket
    $conf_dir         = $nginx::vars::conf_dir
    $csp_policies     = $nginx::vars::csp_policies
    $csp_report       = $nginx::vars::csp_report
    $csp_sources      = $nginx::vars::csp_sources
    $hpkp_max_age     = $nginx::vars::hpkp_max_age
    $hpkp_report      = $nginx::vars::hpkp_report
    $listen_ports     = $nginx::vars::listen_ports
    $log_dir          = $nginx::vars::log_dir
    $public_key_pins  = $nginx::vars::public_key_pins
    $rsyslog_conf_dir = $nginx::vars::rsyslog_conf_dir
    $rsyslog_version  = $nginx::vars::rsyslog_version
    $run_dir          = $nginx::vars::nginx_run_dir

    if ($listen_ports['ssl'] != false) {
	nginx::define::certificate_chain {
	    $name:
	}

	if (defined(Pki::Define::Get["$fqdn server certificate"])) {
	    Pki::Define::Get["$fqdn server certificate"]
		-> Pki::Define::Get["PKI web service chain"]
		-> Nginx::Define::Certificate_chain[$name]
	}
    }

    if (! defined(File["Nginx $name vhost configuration"])) {
	file {
	    "Nginx $name vhost configuration":
		content      => template("nginx/vhost/$vhostsource.erb"),
		group        => hiera("gid_zero"),
		mode         => "0644",
		notify       => Service["nginx"],
		owner        => root,
		path         => "$conf_dir/sites-available/$name.conf";
	}

	if ($vhoststatus == "enabled") {
	    if ($nginx::vars::with_cgi == true or $with_php_fpm != false) {
		if (! defined(File["Install Nginx fastcgi params"])) {
		    file {
			"Install Nginx fastcgi params":
			    group   => hiera("gid_zero"),
			    mode    => "0644",
			    notify  => Service["nginx"],
			    owner   => root,
			    path    => "$conf_dir/fastcgi_params",
			    require => File["Prepare Nginx for further configuration"],
			    source  => "puppet:///modules/nginx/fastcgi_params";
		    }
		}
	    }

	    if ($with_php_fpm != false) {
		if (! defined(Class[Php])) {
		    include php
		}

		if ($vhostrsyslog == true or ($vhostrsyslog == "default" and $nginx::vars::nginx_rsyslog == true)) {
		    $poolrsyslog = true
		} else {
		    $poolrsyslog = false
		}

		php::define::pool {
		    $with_php_fpm:
			listen_group  => $nginx::vars::runtime_group,
			listen_user   => $nginx::vars::runtime_user,
			poolrsyslog   => $poolrsyslog,
			root_dir      => $app_root,
			runtime_group => $fpm_runtime_grp,
			runtime_user  => $fpm_runtime_usr;
		}

		Php::Define::Pool[$with_php_fpm]
		    -> File["Enable Nginx $name vhost configuration"]
	    }

	    file {
		"Enable Nginx $name vhost configuration":
		    ensure       => link,
		    force        => true,
		    notify       => Service["nginx"],
		    path         => "$conf_dir/sites-enabled/$name.conf",
		    target       => "$conf_dir/sites-available/$name.conf";
	    }

	    if ($vhostrsyslog == true or ($vhostrsyslog == "default" and $nginx::vars::nginx_rsyslog == true)) {
		file {
		    "Enable Nginx rsyslog vhost $name configuration":
			content => template("nginx/rsyslog-vhost.erb"),
			group   => hiera("gid_zero"),
			mode    => "0600",
			notify  => Service[$nginx::vars::rsyslog_service_name],
			owner   => root,
			path    => "$rsyslog_conf_dir/rsyslog.d/11_nginx_vhost_$name.conf",
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
			preserve_host   => $preserve_host,
			proxyto         => $proxyaddr,
			pubclear        => $pubclear,
			sslproxy        => $hasssl,
			stricttransport => $stricttransport,
			tag             => "reverse-$domain",
			vhostldapauth   => $revauth,
			vhostrsyslog    => false,
			vhostsource     => "proxy";
		}
	    }
	} else {
	    if ($with_php_fpm != false) {
		php::define::pool {
		    $with_php_fpm:
			ensure => "absent";
		}

		File["Disable Nginx $name vhost configuration"]
		    -> Php::Define::Pool[$with_php_fpm]
	    }

	    file {
		"Disable Nginx $name vhost configuration":
		    ensure  => absent,
		    force   => true,
		    notify  => Service["nginx"];
	    }
	}
    }

    if (defined(Class[Rsyslog]) and
	! defined(File["Enable Nginx rsyslog vhost $name configuration"])) {
	file {
	    "Purge Nginx rsyslog vhost $name configuration":
		ensure  => absent,
		force   => true,
		notify  => Service[$nginx::vars::rsyslog_service_name],
		path    => "$rsyslog_conf_dir/rsyslog.d/11_nginx_vhost_$name.conf";
	}
    }
}
