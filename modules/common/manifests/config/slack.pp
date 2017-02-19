class common::config::slack {
    $cache_ip = hiera("squid_ip")

    file {
	"Install slack notification script":
	    content => template("common/slack.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/slack";
    }
}
