class openvz::rhel {
    $arrayvers = split($operatingsystemrelease, '\.')
    $shortvers = $arrayvers[0]

    yum::define::rpmkey {
	"OpenVZ":
	    key => "0xA7A1D4B6";
    }

    yum::define::repo {
	"openvz-utils":
	    descr      => "OpenVZ user-space utilities",
	    gpgkey     => "http://download.openvz.org/RPM-GPG-Key-OpenVZ",
	    mirrorlist => "http://download.openvz.org/mirrors-current",
	    require    => Exec["Import OpenVZ RPM key"];
	"openvz-kernel-rhel$shortvers":
	    descr      => "OpenVZ RHEL $shorvers-based stable kernels",
	    exclude    => "vzkernel-firmware",
	    gpgkey     => "http://download.openvz.org/RPM-GPG-Key-OpenVZ",
	    mirrorlist => "http://download.openvz.org/kernel/mirrors-rhel$shortvers-$kernelversion",
	    require    => Yum::Define::Repo["openvz-utils"];
    }

    common::define::package {
	[ "vzkernel", "kernel-firmware" ]:
	    require => Yum::Define::Repo["openvz-kernel-rhel$shortvers"];
	"vzkernel-firmware":
	    ensure  => absent,
	    require => Yum::Define::Repo["openvz-kernel-rhel$shortvers"];
    }

    Yum::Define::Repo["openvz-kernel-rhel$shortvers"]
	-> Package["vzctl"]
	-> Package["vzquota"]
}
