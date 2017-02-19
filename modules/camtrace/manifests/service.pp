class camtrace::service {
    common::define::service {
	"slim":
	    ensure     => running;
	"scamd":
	    ensure     => running,
	    hasrestart => false,
	    hasstatus  => false,
	    pattern    => "bin/scamd";
    }
}
