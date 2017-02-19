class peerio::webapp {
    include nginx

    $admin_name   = $peerio::vars::admin_name
    $files_name   = $peerio::vars::files_name
    $inferno_name = $peerio::vars::inferno_name
    $nuts_name    = $peerio::vars::nuts_name
    $shark_name   = $peerio::vars::shark_name
    $website_name = $peerio::vars::website_name
    $workers      = $peerio::vars::workers
    $ws_name      = $peerio::vars::ws_name

    each($workers) |$worker| {
	if ($worker == "foreground" or $worker == "filemgr") {
	    $hname = $worker ? {
		    "filemgr" => $files_name,
		    default   => $ws_name
		}
	    $port = $worker ? {
		    "filemgr" => 8081,
		    default   => 8080
		}

	    nginx::define::vhost {
		$hname:
		    app_port      => $port,
		    csp_name      => "websocket",
		    noerrors      => true,
		    vhostldapauth => "applicative",
		    vhostsource   => "peerio",
		    require       => Exec["Ensure peerio-server running"];
	    }
	} elsif ($worker == "inferno") {
	    nginx::define::vhost {
		$inferno_name:
		    app_port      => 8082,
		    csp_name      => "inferno",
		    noerrors      => true,
		    vhostldapauth => "applicative",
		    vhostsource   => "peerio",
		    require       => Exec["Ensure peerio-inferno running"];
	    }
	} elsif ($worker == "shark") {
	    nginx::define::vhost {
		$shark_name:
		    app_port      => 8083,
		    csp_name      => "shark",
		    noerrors      => true,
		    vhostldapauth => "applicative",
		    vhostsource   => "peerio",
		    require       => Exec["Ensure peerio-shark running"];
	    }
	} elsif ($worker == "nuts") {
	    nginx::define::vhost {
		$shark_name:
		    app_port      => 8010,
		    csp_name      => "nuts",
		    noerrors      => true,
		    vhostldapauth => "applicative",
		    vhostsource   => "peerio",
		    require       => Exec["Ensure peerio-nuts running"];
	    }
	} elsif ($worker == "admin") {
	    nginx::define::vhost {
		$admin_name:
		    app_port      => 8042,
		    csp_name      => "websocket",
		    noerrors      => true,
		    vhostldapauth => "applicative",
		    vhostsource   => "peerio",
		    require       => Exec["Ensure peerio-server running"];
	    }
	}
    }
}
