class pki::jobs {
    cron {
	"List outdated certificates":
	    command  => "/usr/local/bin/dead_certs >/dev/null 2>&1",
	    user     => root,
	    hour     => 10,
	    minute   => 0,
	    monthday => 2;
    }
}
