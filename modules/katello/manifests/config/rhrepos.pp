class katello::config::rhrepos {
    $sat_vers = $katello::vars::sat_vers
    $orgname  = $katello::vars::katello_org

    katello::define::syncplan {
	[ "OSP", "RedHat" ]:
	    interval => "weekly";
    }

    katello::define::medium {
	"RedHat Enterprise Linux Server 7.8":
	    path => "http://$fqdn/pulp/repos/$orgname/Library/content/dist/rhel/server/7/7.8/x86_64/kickstart/";
    }

    katello::define::os {
	"RedHat 7.8":
	    major   => 7,
	    mediums => "RedHat Enterprise Linux Server 7.8",
	    minor   => 8,
	    provs   =>
		[
		    "Custom kickstart",
		    "Kickstart default",
		];
    }

    katello::define::repositoryset {
	[
	    "Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)",
	    "Red Hat Enterprise Linux 8 for x86_64 - BaseOS (Kickstart)",
	    "Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)"
	]:
	    releasever => 8;
	[
	    "Red Hat Ansible Engine 2.4 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server",
	    "Red Hat Enterprise Linux 7 Server - Extras (RPMs)",
	    "Red Hat Enterprise Linux 7 Server - Optional (RPMs)",
	    "Red Hat Enterprise Linux 7 Server - Supplementary (RPMs)",
	    "Red Hat Enterprise Linux 7 Server (RPMs)",
	    "Red Hat OpenShift Container Platform 3.11 (RPMs)",
	    "Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)",
	    "Red Hat Satellite $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Capsule $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Maintenance 6 (for RHEL 7 Server) (RPMs)",
	    "Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)",
	    "Red Hat Software Collections RPMs for Red Hat Enterprise Linux 7 Server"
	]:
	    releasever => "7Server";
	"Red Hat Enterprise Linux 7 Server (Kickstart)":
	    releasever => "7.8";
	[
	    "Red Hat Enterprise Linux 7 Server - Fastrack (RPMs)",
	    "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 (RPMs)"
	]:
    }

    katello::define::product {
	"Red Hat Ansible Engine":
	    require  =>
		[
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.4 RPMs for Red Hat Enterprise Linux 7 Server"],
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server"],
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.8 RPMs for Red Hat Enterprise Linux 7 Server"],
		    Katello::Define::Repositoryset["Red Hat Ansible Engine 2.9 RPMs for Red Hat Enterprise Linux 7 Server"]
		],
	    syncplan => "Ansible";
	"Red Hat OpenShift Container Platform":
	    require  => Katello::Define::Repositoryset["Red Hat OpenShift Container Platform 3.11 (RPMs)"],
	    syncplan => "OCP";
	"Red Hat OpenStack":
	    require  => Katello::Define::Repositoryset["Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)"],
	    syncplan => "OSP";
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
	"Red Hat Ansible Engine 2.4 RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Ansible Engine",
	    shortname => "Red Hat Ansible Engine 2.4 RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server",
	    url       => "rhsm";
	"Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server":
	    product   => "Red Hat Ansible Engine",
	    shortname => "Red Hat Ansible Engine 2.6 RPMs for Red Hat Enterprise Linux 7 Server x86_64 7Server",
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
	    shortname => "Red Hat Enterprise Linux 7 Server - Extras RPMs x86_64 7Server",
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
	    shortname => "Red Hat Enterprise Linux 7 Server Kickstart x86_64 7.8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - AppStream RPMs x86_64 8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - BaseOS (Kickstart)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS Kickstart x86_64 8",
	    url       => "rhsm";
	"Red Hat Enterprise Linux 8 for x86_64 - BaseOS (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Enterprise Linux 8 for x86_64 - BaseOS RPMs x86_64 8",
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
	    shortname => "Red Hat Satellite Maintenance 6 for RHEL 7 Server RPMs x86_64 7Server",
	    url       => "rhsm";
	"Red Hat Satellite Tools $sat_vers (for RHEL 7 Server) (RPMs)":
	    product   => "Red Hat Enterprise Linux Server",
	    shortname => "Red Hat Satellite Tools $sat_vers for RHEL 7 Server RPMs x86_64",
	    url       => "rhsm";
	"Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 (RPMs)":
	    product   => "Red Hat Enterprise Linux for x86_64",
	    shortname => "Red Hat Satellite Tools $sat_vers for RHEL 8 x86_64 RPMs x86_64",
	    url       => "rhsm";

## OCP ##
	"Red Hat OpenShift Container Platform 3.11 (RPMs)":
	    product   => "Red Hat OpenShift Container Platform",
	    shortname => "Red Hat OpenShift Container Platform 3.11 RPMs x86_64 7Server",
	    url       => "rhsm";

## OSP ##
	"Red Hat OpenStack Platform 13 for RHEL 7 (RPMs)":
	    product   => "Red Hat OpenStack",
	    shortname => "Red Hat OpenStack Platform 13 for RHEL 7 RPMs x86_64 7Server",
	    url       => "rhsm";
    }

## OCP/docker ##
    if ($katello::vars::rhregistry_pass and $katello::vars::rhregistry_user) {
	each($katello::vars::ocpimages) |$img| {
	    katello::define::repository {
		"OCP $img":
		    authpass  => $katello::vars::rhregistry_pass,
		    authuser  => $katello::vars::rhregistry_user,
		    dkrname   => $img,
		    product   => "OCP",
		    shortname => $img,
		    type      => "docker",
		    url       => "https://registry.redhat.io/";
	    }
	}
    }
}
