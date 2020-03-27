class postfix::jobs {
    if ($postfix::vars::mail_mx or $postfix::vars::mail_ip) {
	$jobstate = "present"
    } else { $jobstate = "absent" }

    file {
	"Install postfix distributed-bruteforce detection script":
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/find-postfix-corrupted-networks",
	    source  => "puppet:///modules/postfix/find-corrupted-networks";
    }

    cron {
	"Refreshes Postfix Corrupted Networks List":
	    command => "/usr/local/sbin/find-postfix-corrupted-networks >/dev/null 2>&1",
	    ensure  => $jobstate,
	    hour    => "*",
	    minute  => "*/15",
	    require => File["Install postfix distributed-bruteforce detection script"],
	    user    => root;
    }
}
