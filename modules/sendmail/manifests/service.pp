class sendmail::service {
    exec {
	"Refresh submit configuration":
	    command     => "make cf",
	    cwd         => "/etc/mail",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }

    common::define::service {
	"sendmail":
	    ensure    => running,
	    require   => Exec["Refresh submit configuration"],
	    statuscmd => "(ps ax | grep sendmail >/dev/null)";
    }
}
