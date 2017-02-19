class x11vnc::config {
    $contact = $x11vnc::vars::contact

    if $x11vnc::service_runs_as == "root" {
	$runs_as = $x11vnc::service_runs_as
	$homedir = "/root"
    }
    else {
	$basedir = $x11vnc::vars::homedir
	$runs_as = $x11vnc::service_runs_as
	$homedir = "$basedir/$runs_as"
    }

    file {
	"Install x11-VNC wrapper configuration":
	    content => template("x11vnc/vncvars.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/usr/local/etc/vncvars";
	"Install x11-VNC vncpasswd":
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    notify  => Service["x11vnc"],
	    owner   => $runs_as,
	    path    => "$homedir/.vncpasswd",
	    source  => "puppet:///modules/x11vnc/passwd";
    }
}
