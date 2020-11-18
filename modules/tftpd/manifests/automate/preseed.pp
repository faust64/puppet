class tftpd::automate::preseed {
    tftpd::define::ps_devuan {
	"kvm1-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => "kvm";
	"kvm1-man":
	    debvers  => "jessie",
	    server   => "kvm";
	"xen1-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => "xen";
	"xen1-man":
	    debvers  => "jessie",
	    server   => "xen";
	"server1-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => true;
	"server1-man":
	    debvers  => "jessie",
	    server   => true;
	"desktop1-auto":
	    autopart => true,
	    debvers  => "jessie";
	"desktop1-man":
	    debvers  => "jessie";
	"kvm2-auto":
	    autopart => true,
	    debvers  => "ascii",
	    server   => "kvm";
	"kvm2-man":
	    debvers  => "ascii",
	    server   => "kvm";
	"xen2-auto":
	    autopart => true,
	    debvers  => "ascii",
	    server   => "xen";
	"xen2-man":
	    debvers  => "ascii",
	    server   => "xen";
	"server2-auto":
	    autopart => true,
	    debvers  => "ascii",
	    server   => true;
	"server2-man":
	    debvers  => "ascii",
	    server   => true;
	"desktop2-auto":
	    autopart => true,
	    debvers  => "ascii";
	"desktop2-man":
	    debvers  => "ascii";

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
	"jessie-kvm-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => "kvm";
	"jessie-kvm-man":
	    debvers  => "jessie",
	    server   => "kvm";
	"jessie-xen-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => "xen";
	"jessie-xen-man":
	    debvers  => "jessie",
	    server   => "xen";
	"jessie-server-auto":
	    autopart => true,
	    debvers  => "jessie",
	    server   => true;
	"jessie-server-man":
	    debvers  => "jessie",
	    server   => true;
	"jessie-desktop-auto":
	    autopart => true,
	    debvers  => "jessie";
	"jessie-desktop-man":
	    debvers  => "jessie";
	"stretch-kvm-auto":
	    autopart => true,
	    debvers  => "stretch",
	    server   => "kvm";
	"stretch-kvm-man":
	    debvers  => "stretch",
	    server   => "kvm";
	"stretch-xen-auto":
	    autopart => true,
	    debvers  => "stretch",
	    server   => "xen";
	"stretch-xen-man":
	    debvers  => "stretch",
	    server   => "xen";
	"stretch-server-auto":
	    autopart => true,
	    debvers  => "stretch",
	    server   => true;
	"stretch-server-man":
	    debvers  => "stretch",
	    server   => true;
	"stretch-desktop-auto":
	    autopart => true,
	    debvers  => "stretch";
	"stretch-desktop-man":
	    debvers  => "stretch";
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
	"xenial-kvm-auto":
	    autopart => true,
	    ubvers   => "xenial",
	    server   => "kvm";
	"xenial-kvm-man":
	    ubvers   => "xenial",
	    server   => "kvm";
	"xenial-xen-auto":
	    autopart => true,
	    ubvers   => "xenial",
	    server   => "xen";
	"xenial-xen-man":
	    ubvers   => "xenial",
	    server   => "xen";
	"xenial-server-auto":
	    autopart => true,
	    ubvers   => "xenial",
	    server   => true;
	"xenial-server-man":
	    ubvers   => "xenial",
	    server   => true;
	"xenial-desktop-auto":
	    autopart => true,
	    ubvers   => "xenial";
	"xenial-desktop-man":
	    ubvers   => "xenial";
	"bionic-kvm-auto":
	    autopart => true,
	    ubvers   => "bionic",
	    server   => "kvm";
	"bionic-kvm-man":
	    ubvers   => "bionic",
	    server   => "kvm";
	"bionic-xen-auto":
	    autopart => true,
	    ubvers   => "bionic",
	    server   => "xen";
	"bionic-xen-man":
	    ubvers   => "bionic",
	    server   => "xen";
	"bionic-server-auto":
	    autopart => true,
	    ubvers   => "bionic",
	    server   => true;
	"bionic-server-man":
	    ubvers   => "bionic",
	    server   => true;
	"bionic-desktop-auto":
	    autopart => true,
	    ubvers   => "bionic";
	"bionic-desktop-man":
	    ubvers   => "bionic";
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
