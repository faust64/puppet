class freeradius::openbsd {
    common::define::package {
	[ "freeradius", "freeradius-ldap" ]:
    }

    common::define::lined {
	"Enable Freeradius on boot":
	    line => "radiusd_flags=",
	    path => "/etc/rc.conf.local";
    }

    exec {
	"Add Freeradius to pkg_scripts":
	    command => 'echo "pkg_scripts=\"\$pkg_scripts radiusd\"" >>rc.conf.local',
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    require => Common::Define::Lined["Enable Freeradius on boot"],
	    unless  => "grep '^pkg_scripts=.*radiusd' rc.conf.local";
    }

    Common::Define::Package["freeradius"]
	-> File["Prepare Freeradius for further configuration"]
	-> Common::Define::Lined["Enable Freeradius on boot"]
	-> Exec["Add Freeradius to pkg_scripts"]
	-> Common::Define::Service[$freeradius::vars::service_name]
}
