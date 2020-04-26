class katello::config::rhviews {
    katello::define::contentview {
	"CV-base-redhat7":
	    content   =>
		[
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server - Extras (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server - Optional (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server - Optional RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server - Supplementary RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server - Fastrack RPMs x86_64" },
		    { product    => "Red Hat Software Collections (for RHEL Server)",
		      rname      => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server" }
		];
	"CV-base-redhat8":
	    content   =>
		[
		    { product    => "Red Hat Enterprise Linux for x86_64",
		      rname      => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)",
		      repository => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS RPMs x86_64 8" },
		    { product    => "Red Hat Enterprise Linux for x86_64",
		      rname      => "Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)",
		      repository => "Red Hat Enterprise Linux 8 for x86_64 - AppStream RPMs x86_64 8" }
		];
	"CV-capsule6-el7":
	    content   =>
		[
		    { product    => "Red Hat Satellite Capsule",
		      rname      => "Red Hat Satellite Capsule 6.6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Capsule 6.6 for RHEL 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Software Collections (for RHEL Server)",
		      rname      => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server" },
		    { product    => "Red Hat Ansible Engine",
		      rname      => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
		];
	"CV-ocp3-el7":
	    content   =>
		[
		    { product    => "Red Hat OpenShift Container Platform",
		      rname      => "Red Hat OpenShift Container Platform 3.11 (RPMs)",
		      repository => "Red Hat OpenShift Container Platform 3.11 RPMs x86_64 7Server" },
		    { product    => "Red Hat Ansible Engine",
		      rname      => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
		];
	"CV-satellite6-el7":
	    content   =>
		[
		    { product    => "Red Hat Satellite",
		      rname      => "Red Hat Satellite 6.6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite 6.6 for RHEL 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Software Collections (for RHEL Server)",
		      rname      => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server" },
		    { product    => "Red Hat Ansible Engine",
		      rname      => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
		];
	"CV-satellite-tools-el7":
	    content   => [ { product    => "Red Hat Enterprise Linux Server",
			     rname      => "Red Hat Satellite Tools 6.6 (for RHEL 7 Server) (RPMs)",
			     repository => "Red Hat Satellite Tools 6.6 for RHEL 7 Server RPMs x86_64 7Server" } ];
	"CV-satellite-tools-el8":
	    content   => [ { product    => "Red Hat Enterprise Linux for x86_64",
			     rname      => "Red Hat Satellite Tools 6.6 for RHEL 8 x86_64 (RPMs)",
			     repository => "Red Hat Satellite Tools 6.6 for RHEL 8 x86_64 RPMs x86_64" } ];

	"CCV-capsule6":
	    composite => true,
	    content   => [ "CV-base-redhat7", "CV-satellite-tools-el7", "CV-capsule6-el7" ],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-rhel7":
	    composite => true,
	    content   => [ "CV-base-redhat7", "CV-satellite-tools-el7" ],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-rhel8":
	    composite => true,
	    content   => [ "CV-base-redhat8", "CV-satellite-tools-el8" ],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-satellite6":
	    composite => true,
	    content   => [ "CV-base-redhat7", "CV-satellite-tools-el7", "CV-satellite6-el7" ],
	    tolce     => [ "Dev", "Prod" ];
    }

    if ($katello::vars::rhregistry_pass and $katello::vars::rhregistry_user) {
	$ocpimages = $katello::vars::ocpimages
	$dkr       = $ocpimages.map |$img| { { product => "OCP", rname => "OCP $img", repository => $img } }

	katello::define::contentview {
	    "CV-ocp3-docker":
		content   => $dkr;
	    "CCV-OCP-el7":
		composite => true,
		content   =>
		    [
			"CV-base-redhat7", "CV-satellite-tools-el7",
			"CV-ocp3-el7", "CV-ocp3-docker", "CV-Ceph-el7"
		    ],
		tolce     => [ "Dev", "Prod" ];
	}
    } else {
	katello::define::contentview {
	    "CCV-OCP-el7":
		composite => true,
		content   =>
		    [
			"CV-base-redhat7", "CV-satellite-tools-el7",
			"CV-ocp3-el7", "CV-Ceph-el7"
		    ],
		tolce     => [ "Dev", "Prod" ];
	}
    }
}