class common::systemd {
    exec {
	"Reload systemd configuration":
	    command     => "systemctl daemon-reload",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
