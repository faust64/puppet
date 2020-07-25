class bluemind::debian {
    common::define::package {
	"python-memcache":
    }

    Common::Define::Package["python-memcache"]
	-> Nagios::Define::Probe["memcached"]
}
