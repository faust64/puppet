class ossec::authd {
    $conf_dir = $ossec::vars::conf_dir

    file {
	"Install ossec-authd service script":
	    content => template("ossec/authd.rc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/ossec-authd";
    }

    if ($ossec::vars::accept_new_agents == true) {
	exec {
	    "Start ossec-authd":
		command => "/usr/local/sbin/ossec-authd start",
		cwd     => "/",
		path    => "/usr/bin:/bin",
		require => File["Install ossec-authd service script"],
		unless  => "/usr/local/sbin/ossec-authd status";
	}
    } else {
	exec {
	    "Stop ossec-authd":
		command => "/usr/local/sbin/ossec-authd stop",
		cwd     => "/",
		onlyif  => "/usr/local/sbin/ossec-authd status",
		path    => "/usr/bin:/bin",
		require => File["Install ossec-authd service script"];
	}
    }
}
