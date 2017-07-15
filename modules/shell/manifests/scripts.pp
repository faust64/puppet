class shell::scripts {
    file {
	"Install custom WHO command":
	    content => template("shell/who.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/mywho";
    }

    if ($kernel == "Linux") {
	file {
	    "Install dropcache":
		group  => lookup("gid_zero"),
		mode   => "0750",
		owner  => root,
		path   => "/usr/local/sbin/dropcaches",
		source => "puppet:///modules/shell/dropcaches";
	}
    }
}
