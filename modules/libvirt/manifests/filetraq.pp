class libvirt::filetraq {
    filetraq::define::trac {
	"libvirt":
	     pathlist => [ "/etc/libvirt/*" ];
    }
}
