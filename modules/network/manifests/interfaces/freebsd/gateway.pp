define network::interfaces::freebsd::gateway($gw = false) {
    common::define::lined {
	"Configure local gateway":
	    line => "defaultrouter='$gw'",
	    path => "/etc/rc.conf";
    }
}
