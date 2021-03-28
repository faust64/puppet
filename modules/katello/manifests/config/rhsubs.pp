class katello::config::rhsubs {
    $last7    = 9

    katello::define::hostgroup {
	"Capsule":
	    ak           => "AK-Capsule-Prod",
	    cv           => "CCV-capsule6",
	    domain       => "vms.intra.unetresgrossebite.com",
	    lifecycleenv => "Prod",
	    medium       => "RedHat Enterprise Linux Server 7.$last7",
	    subnet       => "VMs";
#	"OCP":
#	    ak           => "AK-OCP-Prod",
#	    cv           => "CCV-OCP-el7",
#	    domain       => "friends.intra.unetresgrossebite.com",
#	    lifecycleenv => "Prod",
#	    subnet       => "Friends";
    }

    katello::define::activationkey {
#	"AK-RHEL-Prod":
#	    collections => [ "Infra" ],
#	    contentview => "CCV-rhel8",
#	    lce         => "Prod";
	"AK-Capsule-Prod":
	    collections => [ "Infra" ],
	    contents    => [ "Red Hat Satellite and Capsule Server for Cloud Providers" ],
	    contentview => "CCV-capsule6",
	    lce         => "Prod";
#	"AK-OCP-Prod":
#	    collections => [ "Infra" ],
#	    contents    =>
#		[
#		    "Ceph",
#		    "Red Hat OpenShift Container Platform Broker/Master Infrastructure"
#		],
#	    contentview => "CCV-OCP-el7",
#	    lce         => "Prod";
    }

    katello::define::policy {
	"Default RHEL7":
	    policy     => "Red Hat rhel7 default content";
	"Default RHEL8":
	    policy     => "Red Hat rhel8 default content";
	"PCI-DSS RHEL7":
	    policy     => "Red Hat rhel7 default content",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
	"PCI-DSS RHEL8":
	    policy     => "Red Hat rhel8 default content",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
    }
}
