class logrotate::rhel {
    common::define::package {
	"logrotate":
    }

    Package["logrotate"]
	-> File["Prepare Logrotate for further configuration"]
}
