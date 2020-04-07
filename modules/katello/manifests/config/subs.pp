class katello::config::subs {
    $org = $katello::vars::katello_org

    katello::define::hostgroup {
	"Ceph":
	    ak           => "AK-Ceph-Prod",
	    cv           => "CCV-Ceph-el7",
	    domain       => "friends.intra.unetresgrossebite.com",
	    lifecycleenv => "Prod",
	    subnet       => "Friends";
	"OKD":
	    ak           => "AK-OKD-Prod",
	    cv           => "CCV-OKD-el7",
	    domain       => "friends.intra.unetresgrossebite.com",
	    lifecycleenv => "Prod",
	    subnet       => "Friends";
    }

    katello::define::activationkey {
	"AK-Ceph-Prod":
	    collections => [ "Infra" ],
	    contents    =>
		[
		    "CentOS", "Ceph", "EPEL", "Foreman",
		    "Katello", "Puppet"
		],
	    contentview => "CCV-Ceph-el7",
	    hasrepos    =>
		[
		    "${org}_CentOS_el7_x86_64_Base",
		    "${org}_CentOS_el7_x86_64_Extras",
		    "${org}_CentOS_el7_x86_64_SCL",
		    "${org}_CentOS_el7_x86_64_Updates",
		    "${org}_Ceph_el7_x86_64_Ceph_Nautilus",
		    "${org}_EPEL_EPEL7_x86_64",
		    "${org}_Foreman_el7_x86_64_TheForeman_1.24_Client",
		    "${org}_Foreman_el7_x86_64_TheForeman_1.24_Plugins",
		    "${org}_Katello_el7_x86_64_Katello_3.14_Pulp",
		    "${org}_Puppet_el7_x86_64_Puppet5"
		],
	    lce         => "Prod";
	"AK-OKD-Prod":
	    collections => [ "Infra" ],
	    contents    =>
		[
		    "CentOS", "OCP", "Ceph", "EPEL",
		    "Foreman", "Katello", "Puppet"
		],
	    contentview => "CCV-OKD-el7",
	    hasrepos    =>
		[
		    "${org}_OCP_el7_x86_64_OKD_3_11",
		    "${org}_CentOS_el7_x86_64_Base",
		    "${org}_CentOS_el7_x86_64_Extras",
		    "${org}_CentOS_el7_x86_64_SCL",
		    "${org}_CentOS_el7_x86_64_Updates",
		    "${org}_Ceph_el7_x86_64_Ceph_Nautilus",
		    "${org}_EPEL_EPEL7_x86_64",
		    "${org}_Foreman_el7_x86_64_TheForeman_1.24_Client",
		    "${org}_Foreman_el7_x86_64_TheForeman_1.24_Plugins",
		    "${org}_Katello_el7_x86_64_Katello_3.14_Pulp",
		    "${org}_Puppet_el7_x86_64_Puppet5"
		],
	    lce         => "Prod";
    }

    katello::define::policy {
	"Default CentOS7":
	    hostgroups => [ "Ceph", "OKD" ],
	    policy     => "Red Hat centos7 default content";
	"PCI-DSS CentOS7":
	    policy     => "Red Hat centos7 default content",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
    }
}
