class ipfw::service {
    common::define::service {
	"ipfw":
	    ensure    => running,
	    statuscmd => "(ipfw list | grep allow >/dev/null)";
    }
}
