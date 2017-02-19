class squid::debian {
    common::define::package {
	"squid3":
    }

    if ($squid::vars::apt_cacher != false) {
	include jesred
    }

    Package["squid3"]
	-> File["Prepare Squid for further configuration"]
}
