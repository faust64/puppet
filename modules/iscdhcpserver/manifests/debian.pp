class iscdhcpserver::debian {
    common::define::package {
	"isc-dhcp-server":
    }

    Package["isc-dhcp-server"]
	-> File["Prepare isc-dhcp-server for further configuration"]
}
