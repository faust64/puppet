class libvirt::profile {
    $uri = $virtual ? {
	    "xen0"  => "xen:///",
	    default => "qemu:///system"
	}

    file {
	"Install libvirt profile configuration":
	    content => template("libvirt/profile.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/profile.d/virsh.sh",
	    require => File["Prepare Profile for further configuration"];
    }
}
