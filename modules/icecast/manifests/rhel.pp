class icecast::rhel {
    common::define::package {
	"icecast":
    }

    Common::Define::Package["icecast"]
	-> Common::Define::Service[$icecast::vars::service_name]
}
