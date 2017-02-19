class x11vnc::scripts {
    $service_dir     = $x11vnc::vars::service_dir
    $service_depends = $x11vnc::service_depends
    $service_runs_as = $x11vnc::service_runs_as

    file {
	"Install x11-VNC init script":
	    content => template("x11vnc/init.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$service_dir/x11vnc";
	"Install x11-VNC wrapper script":
	    content => template("x11vnc/wrapper.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/vncwrapper";
    }
}
