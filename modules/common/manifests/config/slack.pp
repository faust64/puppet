class common::config::slack {
    $cache_ip = lookup("squid_ip")

    file {
	"Install slack notification script":
	    content => template("common/slack.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/slack";
    }
}
