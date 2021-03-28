class katello::config::rhviews {
    $sat_vers = $katello::vars::sat_vers

    katello::define::contentview {
	"CV-base-redhat7":
	    content   =>
		[
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Enterprise Linux 7 Server - Extras (RPMs)",
		      repository => "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64" },
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
		      repository => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS RPMs 8" },
		    { product    => "Red Hat Enterprise Linux for x86_64",
		      rname      => "Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)",
		      repository => "Red Hat Enterprise Linux 8 for x86_64 - AppStream RPMs 8" }
		];
	"CV-capsule6-el7":
	    content   =>
		[
		    { product    => "Red Hat Satellite Capsule",
		      rname      => "Red Hat Satellite Capsule $sat_vers (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Capsule $sat_vers for RHEL 7 Server RPMs x86_64" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64" },
		    { product    => "Red Hat Ansible Engine",
		      rname      => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
		];
#	"CV-rhcs4-el8":
#	    content   =>
#		[
#		    { product    => "Red Hat Ceph Storage",
#		      rname      => "Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 (RPMs)",
#		      repository => "Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 RPMs" },
#		    { product    => "Red Hat Ceph Storage MON",
#		      rname      => "Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 (RPMs)",
#		      repository => "Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 RPMs" },
#		    { product    => "Red Hat Ceph Storage MON",
#		      rname      => "Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 (RPMs)",
#		      repository => "Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 RPMs" },
#		    { product    => "Red Hat Ceph Storage OSD",
#		      rname      => "Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 (RPMs)",
#		      repository => "Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 RPMs" }
#		];
#	"CV-ocp3-el7":
#	    content   =>
#		[
#		    { product    => "Red Hat OpenShift Container Platform",
#		      rname      => "Red Hat OpenShift Container Platform 3.11 (RPMs)",
#		      repository => "Red Hat OpenShift Container Platform 3.11 RPMs x86_64 7Server" },
#		    { product    => "Red Hat Ansible Engine",
#		      rname      => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server",
#		      repository => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
#		];
	"CV-satellite6-el7":
	    content   =>
		[
		    { product    => "Red Hat Satellite",
		      rname      => "Red Hat Satellite $sat_vers (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite $sat_vers for RHEL 7 Server RPMs x86_64" },
		    { product    => "Red Hat Enterprise Linux Server",
		      rname      => "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
		      repository => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64" },
		    { product    => "Red Hat Ansible Engine",
		      rname      => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server",
		      repository => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server x86_64" }
		];
	"CV-satellite-tools-el7":
	    content   => [ { product    => "Red Hat Enterprise Linux Server",
			     rname      => "Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)",
			     repository => "Red Hat Satellite Tools $sat_vers for RHEL 7 Server RPMs x86_64" } ];
	"CV-satellite-tools-el8":
	    content   => [ { product    => "Red Hat Enterprise Linux for x86_64",
			     rname      => "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 (RPMs)",
			     repository => "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 RPMs" } ];

	"CCV-capsule6":
	    composite => true,
	    content   => [ "CV-base-redhat7", "CV-satellite-tools-el7", "CV-capsule6-el7" ],
	    tolce     => [ "Dev", "Prod" ];
#	"CCV-rhcs-el8":
#	    composite => true,
#	    content   => [ "CV-base-redhat8", "CV-satellite-tools-el8", "CV-rhcs4-el8" ],
#	    tolce     => [ "Dev", "Prod" ];
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
#	"CCV-OCP-el7":
#	    composite => true,
#	    content   =>
#		[
#		    "CV-base-redhat7", "CV-satellite-tools-el7",
#		    "CV-ocp3-el7", "CV-Ceph-el7", "CV-EPEL-el7"
#		],
#	    tolce     => [ "Dev", "Prod" ];
    }

#    if ($katello::vars::rhregistry_pass and $katello::vars::rhregistry_user) {
#	$ocpimages = $katello::vars::ocpimages
#	$dkr       = $ocpimages.map |$img| { { product => "OCP", rname => "OCP $img", repository => $img } }
#
#	katello::define::contentview {
#	    "CV-ocp3-docker":
#		content   => $dkr;
#	}
#    }
}
