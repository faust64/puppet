class libvirt::config {
    $runtime_group = $libvirt::vars::runtime_group
    $runtime_user  = $libvirt::vars::runtime_user

    file {
	"Prepare libvirt for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/libvirt";
	"Install qemu configuration file":
	    content => template("libvirt/qemu.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => root,
	    path    => "/etc/libvirt/qemu.conf",
	    require => File["Prepare libvirt for further configuration"];
	"Prepare libvirt qemu configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/libvirt/qemu",
	    require => File["Prepare libvirt for further configuration"];
	"Prepare libvirt autostart configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/libvirt/qemu/autostart",
	    require => File["Prepare libvirt qemu configuration directory"];
    }
}
