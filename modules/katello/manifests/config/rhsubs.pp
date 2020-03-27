class katello::config::rhsubs {
    katello::define::hostgroup {
	"Capsule":
	    cv           => "CCV-capsule6",
	    domain       => "vms.intra.unetresgrossebite.com",
	    lifecycleenv => "Prod",
	    subnet       => "VMs";
	"OCP":
	    cv           => "CCV-OCP-el7",
	    domain       => "friends.intra.unetresgrossebite.com",
	    lifecycleenv => "Prod",
	    subnet       => "Friends";
    }

    katello::define::activationkey {
	"AK-Capsule-Prod":
	    collections => [ "Infra" ],
	    contents    => [ "Red Hat Satellite and Capsule Server for Cloud Providers" ],
	    contentview => "CCV-capsule6",
	    lce         => "Prod";
	"AK-OCP-Prod":
	    collections => [ "Infra" ],
	    contents    =>
		[
		    "Ceph",
		    "Red Hat OpenShift Container Platform Broker/Master Infrastructure"
		],
	    contentview => "CCV-OCP-el7",
	    lce         => "Prod";
    }

    katello::define::policy {
	"Default RHEL7":
	    policy     => "Red Hat rhel7 default content";
	"PCI-DSS RHEL7":
	    policy     => "Red Hat rhel7 default content",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
    }
}
