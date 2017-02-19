class jesred::config {
    $apt_cacher  = $jesred::vars::apt_cacher
    $log_dir     = $jesred::vars::log_dir
    $regexprlist = $jesred::vars::regexplist
    $rewrite_for = $jesred::vars::rewrite_for

    file {
	"Install jesred main configuration":
	    content => template("jesred/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/jesred.conf";
	"Install jesred rules configuration":
	    content => template("jesred/rules.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/jesred.rules";
	"Install jesred acl configuration":
	    content => template("jesred/acl.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/jesred.acl";
    }
}
