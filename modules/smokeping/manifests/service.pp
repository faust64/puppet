class smokeping::service {
    $match = "[/]smokeping"

    common::define::service {
	"smokeping":
	    ensure    => running,
	    hasstatus => false,
	    statuscmd => "ps ax | grep '$match'";
    }
}
