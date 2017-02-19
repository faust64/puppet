class kibana::service {
    common::define::service {
	"kibana":
	    ensure => running;
    }

    if ($kibana::vars::esearch_listen == $ipaddress or $kibana::vars::esearch_listen == "127.0.0.1") {
	Service["elasticsearch"]
	    ~> Service["kibana"]
    }
}
