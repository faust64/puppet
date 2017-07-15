class libvirt::logrotate {
    file {
	"Install libvirt logrotate configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/logrotate.d/libvirtd",
	    require => File["Prepare Logrotate for further configuration"],
	    source  => "puppet:///modules/libvirt/logrotate";
	"Drop duplicate logrotate configuration":
	    ensure  => absent,
	    force   => true,
	    path    => "/etc/logrotate.d/libvirtd.qemu",
	    require => File["Prepare Logrotate for further configuration"];
    }
}
