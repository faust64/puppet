class bluemind::debian {
    common::define::package {
	[
	    "bm-plugin-admin-console-ldap-import",
	    "bm-plugin-core-ldap-import",
	    "bm-plugin-core-mapi-support"
	]:
	    notify => Exec["Restarts BlueMind"];
	"python-memcache":
    }

    exec {
	"Restarts BlueMind":
	    command     => "bmctl restart",
	    path        => "/sbin:/usr/sbin:/bin:/usr/bin",
	    refreshonly => true;
    }

    Common::Define::Package["python-memcache"]
	-> Nagios::Define::Probe["memcached"]
}
