class muninnode::openbsd {
    common::define::package {
	"munin-node":
    }

    file_line {
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
	    require => File_line["Enable Munin-Node on boot"],
	    unless  => "grep '^pkg_scripts=.*munin_node' rc.conf.local";
    }

    Package["munin-node"]
	-> File["Install Munin custom plugins"]
	-> File_line["Enable Munin-Node on boot"]
	-> Exec["Add Munin-Node to pkg_scripts"]
	-> File_line["Ensure munin knows where to listen"]
	-> Common::Define::Service[$muninnode::vars::munin_node_service_name]
}
