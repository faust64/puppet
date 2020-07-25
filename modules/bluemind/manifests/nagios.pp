class bluemind::nagios {
    nagios::define::probe {
	"bm-core":
            alias         => "core",
            command       => "check_procs",
	    description   => "$fqdn bm-core service",
	    pluginargs    =>
		[
		    '-C', 'java', '-a',
		    'bm-core.log.xml'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-cyrus-imapd":
            alias         => "cyrus-imap",
            command       => "check_imap",
	    description   => "$fqdn bm-cyrus-imapd service",
	    pluginargs    =>
		[
		    '-H', '127.0.0.1',
		    '-p', '24',
		    '-e', "$hostname"
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-eas":
            alias         => "eas",
            command       => "check_http",
	    description   => "$fqdn bm-eas service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8082',
		    '-e', '400'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-elasticsearch":
            alias         => "elasticsearch",
            command       => "check_http",
	    description   => "$fqdn bm-elasticsearch service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '9200', '--url',
		    '"/_cluster/health?wait_for_status=green&timeout=10s"',
		    '-s', 'green'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-hps":
            alias         => "hps",
            command       => "check_http",
	    description   => "$fqdn bm-hps service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8079'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-locator":
            alias         => "locator",
            command       => "check_http",
	    description   => "$fqdn bm-locator service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8084',
		    '-e', '404'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-lmtpd":
            alias         => "lmtpd",
            command       => "check_imap",
	    description   => "$fqdn bm-lmtpd service",
	    pluginargs    =>
		[
		    '-H', '127.0.0.1',
		    '-p', '2400',
		    '-e', "$hostname"
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-milter":
            alias         => "milter",
            command       => "check_procs",
	    description   => "$fqdn bm-milter service",
	    pluginargs    =>
		[
		    '-C', 'java', '-a',
		    'bm-milter.log.xml'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-nginx":
            alias         => "nginx",
            command       => "check_http",
	    description   => "$fqdn bm-nginx service",
	    pluginargs    =>
		[
		    '-H', "$fqdn",
		    '-p', '443', '-S'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-node":
            alias         => "node",
            command       => "check_procs",
	    description   => "$fqdn bm-node service",
	    pluginargs    =>
		[
		    '-C', 'java', '-a',
		    'bm-node.log.xml'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-php-fpm":
            alias         => "php-fpm",
            command       => "check_procs",
	    description   => "$fqdn bm-php-fpm service",
	    pluginargs    =>
		[
		    '-C', 'php-fpm',
		    '-c', '10:15',
		    '-w', '8:20'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-postgresql":
            alias         => "postgres",
            command       => "check_pgsql",
	    description   => "$fqdn bm-postgres service",
	    pluginargs    =>
		[
		    '-H', '127.0.0.1',
		    '-d', 'bj',
		    '-l', 'bj', '-p', 'bj'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-sds-proxy":
            alias         => "sds",
            command       => "check_http",
	    description   => "$fqdn bm-sds-proxy service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8091',
		    '-e', '400'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-tika":
            alias         => "tika",
            command       => "check_http",
	    description   => "$fqdn bm-tika service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8087',
		    '-e', '404'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-webserver":
            alias         => "webserver",
            command       => "check_http",
	    description   => "$fqdn bm-webserver service",
	    pluginargs    =>
		[
		    '-H', '127.0.0.1',
		    '-p', '8080', '-s',
		    "\"window.location.replace('/settings/')\""
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-xmpp":
            alias         => "xmpp",
            command       => "check_procs",
	    description   => "$fqdn bm-xmpp service",
	    pluginargs    =>
		[
		    '-C', 'java', '-a',
		    'bm-xmpp.log.xml'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"bm-ysnp":
            alias         => "ysnp",
            command       => "check_procs",
	    description   => "$fqdn bm-ysnp service",
	    pluginargs    =>
		[
		    '-C', 'java', '-a',
		    'bm-ysnp.log.xml'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"chronograf":
            alias         => "chronograf",
            command       => "check_http",
	    description   => "$fqdn chronograf service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '8888',
		    '-e', '404'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"kapacitor":
            alias         => "kapacitor",
            command       => "check_http",
	    description   => "$fqdn kapacitor service",
	    pluginargs    =>
		[
		    '-I', '127.0.0.1',
		    '-p', '9092',
		    '-e', '404'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
	"memcached":
            alias         => "memcached",
	    description   => "$fqdn memcache service",
            command       => "check_memcached",
	    pluginargs    =>
		[
		    '-H', '127.0.0.1',
		    '-p', '11211'
		],
	    pluginconf    => "default",
	    servicegroups => "netservices",
	    use           => "warning-service";
    }
## TODO:
# * bm-pimp ??
}
