class openvz::common {
    common::define::package {
	[ "bridge-utils", "vlan", "vzctl", "vzquota" ]:
    }

    common::define::insertmodule { $openvz::vars::openvz_modules: }

    include mysysctl::define::forwarding
    mysysctl::define::setfile {
	"openvz":
	    source => "openvz/sysctl.conf";
    }

    file {
	"Prepare our vz root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/vz";
	"Link to vz root directory":
	    ensure  => link,
	    force   => true,
	    path    => $openvz::vars::vz_root,
	    target  => "/vz";
    }
}
