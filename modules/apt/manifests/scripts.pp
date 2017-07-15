class apt::scripts {
    $contact    = $apt::vars::contact
    $slack_hook = $apt::vars::slack_hook

    file {
	"Install .dpkg-dist finder":
	    content => template("apt/dpkg-dist.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/dpkg-dist_removed";
	"Install half-removed packages finder":
	    content => template("apt/removed.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/apt_removed";
    }
}
