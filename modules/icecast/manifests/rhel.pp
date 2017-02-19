class icecast::rhel {
    common::define::package {
	"icecast":
    }

    Package["icecast"]
	-> Service[$icecast::vars::service_name]
}
