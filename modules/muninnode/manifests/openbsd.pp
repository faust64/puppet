class muninnode::openbsd {
    common::define::package {
	"munin-node":
    }

    common::define::lined {
	"Enable Munin-Node on boot":
	    line    => "munin_node_flags=",
	    path    => "/etc/rc.conf.local";
	"Patch smart_ probe python version":
	    line    => "#!/usr/bin/env python",
	    match   => "^#!/usr/bin/env python.*",
	    path    => "/usr/local/libexec/munin/plugins/smart_",
	    require => Common::Define::Package["munin-node"];
    }

    exec {
	"Add Munin-Node to pkg_scripts":
	    command => 'echo "pkg_scripts=\"\$pkg_scripts munin_node\"" >>rc.conf.local',
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    require => Common::Define::Lined["Enable Munin-Node on boot"],
	    unless  => "grep '^pkg_scripts=.*munin_node' rc.conf.local";
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> Common::Define::Lined["Enable Munin-Node on boot"]
	-> Exec["Add Munin-Node to pkg_scripts"]
	-> Common::Define::Lined["Ensure munin knows where to listen"]
	-> Common::Define::Service[$muninnode::vars::munin_node_service_name]
}
