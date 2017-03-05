class haproxy::nagios {
    if ($haproxy::vars::backends) {
	each($haproxy::vars::backends) |$backend| {
	    $port       = $backend['port']
	    $balancer   = $backend['name']
	    if ($backend['listen']) {
		$listen = $backend['listen']
	    } else {
		$listen = $haproxy::vars::listen
	    }
	    if ($backend['mode'] == 'http') {
		$command = "check_http"
	    } elsif ($backend['mode'] == 'tcp') {
		if ($backend['type'] == 'redis') {
		    $command = "check_redis"
		} elsif ($backend['type'] == 'mysql') {
		    $command = "check_mysql"
		} elsif ($backend['type'] == 'postgresql') {
		    $command = "check_psql"
		} else {
		    $command = "check_tcp"
		}
	    } elsif ($haproxy::vars::default_mode == 'http') {
		$command = "check_http"
	    } else {
		if ($backend['type'] == 'redis') {
		    $command = "check_redis"
		} elsif ($backend['type'] == 'mysql') {
		    $command = "check_mysql"
		} elsif ($backend['type'] == 'postgresql') {
		    $command = "check_pgsql"
		} else {
		    $command = "check_tcp"
		}
	    }
	    if ($command == "check_http") {
		$serviceclass = "webservices"
		if ($backend['check_hostname']) {
		    $hname = $backend['check_hostname']
		} else {
		    $hname = $ipaddress
		}
		if ($backend['check_url']) {
		    $uri = $backend['check_url']
		} elsif ($backend['type'] == 'riak') {
		    $uri = "/ping"
		} elsif ($backend['type'] == 'riakcs') {
		    $uri = "/riak-cs/ping"
		} else {
		    $uri = "/"
		}
		if ($backend['port'] == '443' or $backend['port'] == 443 or $backend['ssl']) {
		    if ($backend['type'] == 'riak') {
			$connect = [ "--ssl", "-u", "https://$hname$uri", "-H", $listen, "-p", $port, "-e", "401" ]
		    } else {
			$connect = [ "--ssl", "-u", "https://$hname$uri", "-H", $listen, "-p", $port ]
		    }
		} else {
		    $connect = [ "-u", "http://$hname$uri", "-H", $listen, "-p", $port ]
		}
	    } elsif ($command == "check_mysql") {
		if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
		    or $operatingsystem == "Ubuntu") {
		    $dep = "mysql-client"
		} elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
		    $dep = "mysql"
		} else {
		    $dep = false
		}
		if ($dep) {
		    common::define::package { $dep: }
		}
		$serviceclass = "databases"
		if ($backend['nagios_auth_user'] and $backend['nagios_auth_pass']) {
		    $usr = $backend['nagios_auth_user']
		    $pw  = $backend['nagios_auth_pass']
		    $connect = [ "-u", $usr, "-p", "'$pw'", "-H", $listen, "-P", $port ]
		} elsif ($backend['nagios_auth_user']) {
		    $usr = $backend['nagios_auth_user']
		    $connect = [ "-u", $usr, "-H", $listen, "-P", $port ]
		} else {
		    $connect = [ "-H", $listen, "-P", $port ]
		}
	    } elsif ($command == "check_pgsql") {
		if ($operatingsystem == "Debian" or $myoperatingsystem == "Devuan"
		    or $operatingsystem == "Ubuntu") {
		    $dep = "libpq-dev"
		} elsif ($operatingsystem == "CentOS" or $operatingsystem == "RedHat") {
		    $dep = "postgresql-libs"
		} else {
		    $dep = false
		}
		if ($dep) {
		    common::define::package { $dep: }
		}
		$serviceclass = "databases"
		if ($backend['nagios_auth_user'] and $backend['nagios_auth_pass']) {
		    $usr = $backend['nagios_auth_user']
		    $pw  = $backend['nagios_auth_pass']
		    $authstr = "-l $usr -p '$pw'"
		} elsif ($backend['nagios_auth_user']) {
		    $usr = $backend['nagios_auth_user']
		    $authstr = "-l $usr"
		} else {
		    $authstr = ""
		}
		$connect = [ "-H", $listen, "-P", $port, $authstr ]
	    } elsif ($command == "check_redis") {
		include common::libs::perlnagiosplugin
		include common::libs::perlredis
		$serviceclass = "databases"
		$connect = [ "-H", $listen, "-p", $port ]
	    } elsif ($backend['ssl']) {
		$serviceclass = "webservices"
		$connect = [ "--ssl", "-H", $listen, "-p", $port ]
	    } else {
		$serviceclass = "webservices"
		$connect = [ "-H", $listen, "-p", $port ]
	    }

	    nagios::define::probe {
		"haproxy_$balancer":
		    command       => $command,
		    description   => "$fqdn haproxy $balancer",
		    pluginargs    => $connect,
		    servicegroups => $serviceclass,
		    use           => "critical-service";
	    }
	}
    }
}
