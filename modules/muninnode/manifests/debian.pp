class muninnode::debian {
    common::define::package {
	"munin-node":
    }

    if ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn") {
	if ($lsbdistcodename == "trusty" or $lsbdistcodename == "precise") {
	    common::define::package {
		"conntrack":
	    }

	    Package["conntrack"]
		-> Package["munin-node"]
	}
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> File_line["Ensure munin knows where to listen"]
}
