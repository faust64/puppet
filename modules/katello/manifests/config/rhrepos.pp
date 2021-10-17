class katello::config::rhrepos {
    $last7    = 9
    $last8    = 3
    $orgname  = $katello::vars::katello_org
    $sat_vers = $katello::vars::sat_vers

    katello::define::syncplan {
	[ "OSP", "RedHat" ]:
	    interval => "weekly",
	    status   => "disabled";
    }

    katello::define::medium {
	"RedHat Enterprise Linux Server 7.$last7":
	    path => "http://$fqdn/pulp/repos/$orgname/Library/content/dist/rhel/server/7/7.$last7/x86_64/kickstart/";
	"RedHat Enterprise Linux Server 8.$last8":
	    path => "http://$fqdn/pulp/repos/$orgname/Library/content/dist/rhel8/8.$last8/x86_64/baseos/kickstart/";
    }

    katello::define::os {
	"RedHat7.$last7":
	    major   => 7,
	    mediums => [ "RedHat Enterprise Linux Server 7.$last7" ],
	    minor   => $last7,
	    provs   =>
		[
		    "Custom kickstart",
		    "Kickstart default",
		];
	"RedHat8.$last8":
	    major   => 8,
	    mediums => [ "RedHat Enterprise Linux Server 8.$last8" ],
	    minor   => $last8,
	    provs   =>
		[
		    "Custom kickstart",
		    "Kickstart default",
		];
    }

    katello::define::repositoryset {
	[
#	    "Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 (RPMs)",
#	    "Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 (RPMs)",
#	    "Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 (RPMs)",
#	    "Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 (RPMs)",
	    "Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)",
	    "Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)"
	]:
	    releasever => 8;
	[
	    "Red Hat Enterprise Linux 8 for x86_64 - AppStream (Kickstart)",
	    "Red Hat Enterprise Linux 8 for x86_64 - BaseOS (Kickstart)"
	]:
	    releasever => "8.$last8";
	[
	    "Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Enterprise Linux 7 Server - Extras (RPMs)",
	    "Red Hat Enterprise Linux 7 Server - Optional (RPMs)",
	    "Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)",
	    "Red Hat Enterprise Linux 7 Server (RPMs)",
#	    "Red Hat OpenShift Container Platform 3.11 (RPMs)",
#	    "Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)",
	    "Red Hat Satellite $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Capsule $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server"
	]:
	    releasever => "7Server";
	"Red Hat Enterprise Linux 7 Server (Kickstart)":
	    releasever => "7.$last7";
	[
	    "Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)",
	    "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 (RPMs)"
	]:
    }

    katello::define::product {
	"Red Hat Ansible Engine":
	    require  =>
		[
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server"],
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server"],
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server"]
		],
	    syncplan => "Ansible";
#	"Red Hat Ceph Storage":
#	    require  => Katello::Define::Repositoryset["Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 (RPMs)"],
#	    syncplan => "Ceph";
#	"Red Hat Ceph Storage MON":
#	    require  =>
#		[
#		    Katello::Define::Repositoryset["Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 (RPMs)"],
#		    Katello::Define::Repositoryset["Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 (RPMs)"],
#		],
#	    syncplan => "Ceph";
#	"Red Hat Ceph Storage OSD":
#	    require  => Katello::Define::Repositoryset["Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 (RPMs)"],
#	    syncplan => "Ceph";
#	"Red Hat OpenShift Container Platform":
#	    require  => Katello::Define::Repositoryset["Red Hat OpenShift Container Platform 3.11 (RPMs)"],
#	    syncplan => "OCP";
#	"Red Hat OpenStack":
#	    require  => Katello::Define::Repositoryset["Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)"],
#	    syncplan => "OSP";
	[ "Red Hat Satellite", "Red Hat Satellite Capsule" ]:
	    require  =>
		[
		    Katello::Define::Repositoryset["Red Hat Satellite $sat_vers (for RHEL 7 Server) (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Satellite Capsule $sat_vers (for RHEL 7 Server) (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)"]
		],
	    syncplan => "Products";
	"Red Hat Enterprise Linux for x86_64":
	    require  =>
		[
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 8 for x86_64 - AppStream (Kickstart)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 8 for x86_64 - BaseOS (Kickstart)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)"]
		],
	    syncplan => "RedHat";
	"Red Hat Enterprise Linux Server":
	    require  =>
		[
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server - Extras (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server - Optional (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server (Kickstart)"],
		    Katello::Define::Repositoryset["Red Hat Enterprise Linux 7 Server (RPMs)"]
		],
	    syncplan => "RedHat";
	"Red Hat Software Collections (for RHEL Server)":
	    require  => Katello::Define::Repositoryset["Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server"],
	    syncplan => "RedHat";
    }

    katello::define::repository {
## Ansible ##
	"Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Ansible Engine",
	    shortname => "Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server x86_64",
	    url       => "rhsm";
	"Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Ansible Engine",
	    shortname => "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server x86_64",
	    url       => "rhsm";
	"Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Ansible Engine",
	    shortname => "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server x86_64",
	    url       => "rhsm";

## RedHat ##
	"Red Hat Enterprise Linux 7 Server (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server RPMs x86_64 7Server",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 7 Server - Extras (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 7 Server - Optional (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server - Optional RPMs x86_64 7Server",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server - Supplementary RPMs x86_64 7Server",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server - Fastrack RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 7 Server (Kickstart)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Enterprise Linux 7 Server Kickstart x86_64 7.$last7",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - AppStream RPMs 8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - AppStream (Kickstart)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - AppStream Kickstart 8.$last8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS RPMs 8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - BaseOS (Kickstart)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS Kickstart 8.$last8",
	    url       => "rhsm";
	"Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Software Collections (for RHEL Server)",
	    shortname => "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server",
	    url       => "rhsm";

## Satellite ##
	"Red Hat Satellite $sat_vers (for RHEL 7 Server) (RPMs)":
	    product   => "Red Hat Satellite",
	    shortname => "Red Hat Satellite $sat_vers for RHEL 7 Server RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Satellite Capsule $sat_vers (for RHEL 7 Server) (RPMs)":
	    product   => "Red Hat Satellite Capsule",
	    shortname => "Red Hat Satellite Capsule $sat_vers for RHEL 7 Server RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Satellite Tools $sat_vers for RHEL 7 Server RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 RPMs",
	    url       => "rhsm";

## Ceph ##
#	"Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 (RPMs)":
#	    product   => "Red Hat Ceph Storage",
#	    shortname => "Red Hat Ceph Storage Tools 4 for RHEL 8 x86_64 RPMs",
#	    url       => "rhsm";

#	"Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 (RPMs)":
#	    product   => "Red Hat Ceph Storage MON",
#	    shortname => "Red Hat Ceph Storage 4 Text-Only Advisories for RHEL 8 x86_64 RPMs",
#	    url       => "rhsm";
#	"Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 (RPMs)":
#	    product   => "Red Hat Ceph Storage MON",
#	    shortname => "Red Hat Ceph Storage MON 4 for RHEL 8 x86_64 RPMs",
#	    url       => "rhsm";
#	"Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 (RPMs)":
#	    product   => "Red Hat Ceph Storage OSD",
#	    shortname => "Red Hat Ceph Storage OSD 4 for RHEL 8 x86_64 RPMs",
#	    url       => "rhsm";

## OCP ##
#	"Red Hat OpenShift Container Platform 3.11 (RPMs)":
#	    product   => "Red Hat OpenShift Container Platform",
#	    shortname => "Red Hat OpenShift Container Platform 3.11 RPMs x86_64 7Server",
#	    url       => "rhsm";

## OSP ##
#	"Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)":
#	    product   => "Red Hat OpenStack",
#	    shortname => "Red Hat OpenStack Platform 13 for RHEL 7 RPMs x86_64 7Server",
#	    url       => "rhsm";
    }

## OCP/docker ##
#    if ($katello::vars::rhregistry_pass and $katello::vars::rhregistry_user) {
#	each($katello::vars::ocpimages) |$img| {
#	    katello::define::repository {
#		"OCP $img":
#		    authpass  => $katello::vars::rhregistry_pass,
#		    authuser  => $katello::vars::rhregistry_user,
#		    dkrname   => $img,
#		    product   => "OCP",
#		    shortname => $img,
#		    type      => "docker",
#		    url       => "https://registry.redhat.io/";
#	    }
#	}
#    }
}
