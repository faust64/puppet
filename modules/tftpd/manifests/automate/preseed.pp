class tftpd::automate::preseed {
    tftpd::define::ps_debian {
	"squeeze-vz-auto":
	    autopart => true,
	    debvers  => "squeeze",
	    server   => "openvz";
	"squeeze-vz-man":
	    debvers  => "squeeze",
	    server   => "openvz";
	"squeeze-kvm-auto":
	    autopart => true,
	    debvers  => "squeeze",
	    server   => "kvm";
	"squeeze-kvm-man":
	    debvers  => "squeeze",
	    server   => "kvm";
	"squeeze-xen-auto":
	    autopart => true,
	    debvers  => "squeeze",
	    server   => "xen";
	"squeeze-xen-man":
	    debvers  => "squeeze",
	    server   => "xen";
	"squeeze-server-auto":
	    autopart => true,
	    debvers  => "squeeze",
	    server   => true;
	"squeeze-server-man":
	    debvers  => "squeeze",
	    server   => true;
	"squeeze-desktop-auto":
	    autopart => true,
	    debvers  => "squeeze";
	"squeeze-desktop-man":
	    debvers  => "squeeze";
	"wheezy-kvm-auto":
	    autopart => true,
	    debvers  => "wheezy",
	    server   => "kvm";
	"wheezy-kvm-man":
	    debvers  => "wheezy",
	    server   => "kvm";
	"wheezy-xen-auto":
	    autopart => true,
	    debvers  => "wheezy",
	    server   => "xen";
	"wheezy-xen-man":
	    debvers  => "wheezy",
	    server   => "xen";
	"wheezy-server-auto":
	    autopart => true,
	    debvers  => "wheezy",
	    server   => true;
	"wheezy-server-man":
	    debvers  => "wheezy",
	    server   => true;
	"wheezy-desktop-auto":
	    autopart => true,
	    debvers  => "wheezy";
	"wheezy-desktop-man":
	    debvers  => "wheezy";
	"kvm-auto":
	    autopart => true,
	    server   => "kvm";
	"kvm-man":
	    server   => "kvm";
	"xen-auto":
	    autopart => true,
	    server   => "xen";
	"xen-man":
	    server   => "xen";
	"server-auto":
	    autopart => true,
	    server   => true;
	"server-man":
	    server   => true;
	"desktop-auto":
	    autopart => true;
	"desktop-man":
    }

    tftpd::define::ps_ubuntu {
	"precise-kvm-auto":
	    autopart => true,
	    server   => "kvm",
	    ubvers   => "precise";
	"precise-kvm-man":
	    server   => "kvm",
	    ubvers   => "precise";
	"precise-xen-auto":
	    autopart => true,
	    server   => "xen",
	    ubvers   => "precise";
	"precise-xen-man":
	    server   => "xen",
	    ubvers   => "precise";
	"precise-server-auto":
	    autopart => true,
	    server   => true,
	    ubvers   => "precise";
	"precise-server-man":
	    server   => true,
	    ubvers   => "precise";
	"precise-desktop-auto":
	    autopart => true,
	    ubvers   => "precise";
	"precise-desktop-man":
	    ubvers   => "precise";
	"kvm-auto":
	    autopart => true,
	    server   => "kvm";
	"kvm-man":
	    server   => "kvm";
	"xen-auto":
	    autopart => true,
	    server   => "xen";
	"xen-man":
	    server   => "xen";
	"server-auto":
	    autopart => true,
	    server   => true;
	"server-man":
	    server   => true;
	"desktop-auto":
	    autopart => true;
	"desktop-man":
    }
}
