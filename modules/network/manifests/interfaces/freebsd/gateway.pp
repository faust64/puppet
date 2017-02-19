define network::interfaces::freebsd::gateway($gw = false) {
    file_line {
	"Configure local gateway":
	    line => "defaultrouter='$gw'",
	    path => "/etc/rc.conf";
    }
}
