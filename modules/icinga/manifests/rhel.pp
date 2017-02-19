class icinga::rhel {
    yum::define::repo {
	"Icinga":
	    baseurl => "http://packages.icinga.org/epel/\$releasever/release/",
	    descr   => "ICINGA (stable release)",
	    gpgkey  => "http://packages.icinga.org/icinga.key";
    }

    common::define::package {
	[ "check-mk-livestatus", "nagios-plugins-nrpe", "icinga" ]:
	    require => Yum::Define::Repo["Icinga"];
    }

    Package["check-mk-livestatus"]
	-> Package["nagios-nrpe-plugin"]
	-> Package["nagios-plugins-nrpe"]
	-> Package["icinga"]
	-> File["Install check_nrpe plugin configuration"]
	-> Icinga::Define::Config["icinga.cfg"]

    Package["icinga"]
	-> File["Prepare Icinga main configuration directory"]
	-> File["Prepare Icinga cache directory"]
	-> File["Prepare Icinga lib directory"]
	-> File["Prepare Icinga logs directory"]
	-> File["Prepare Icinga run directory"]
}
