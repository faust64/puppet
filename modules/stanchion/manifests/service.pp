class stanchion::service {
    common::define::service {
	"stanchion":
	    ensure => running;
    }

    if (defined(Class["riakcs"])) {
	Common::Define::Service["riak-cs"]
	    -> Common::Define::Service["stanchion"]
    }
}
