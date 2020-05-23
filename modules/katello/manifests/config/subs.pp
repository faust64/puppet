class katello::config::subs {
    $ktlvers = $katello::vars::katello_version
    $org     = $katello::vars::katello_org
    $tfmvers = $katello::vars::theforeman_version

    katello::define::hostgroup {
	"Ceph":
	    ak           => "AK-Ceph-Prod",
	    cv           => "CCV-Ceph-el8",
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

    if ($tfmvers == "1.24" or $tfmvers == 1.24) {
	$pulprepo = "Pulp"
    } else { $pulprepo = "Pulpcore" }

    katello::define::activationkey {
	"AK-Ceph-Prod":
	    collections => [ "Infra" ],
	    contents    =>
		[
		    "CentOS", "Ceph", "EPEL", "Foreman",
		    "Katello", "Puppet"
		],
	    contentview => "CCV-Ceph-el8",
	    hasrepos    =>
		[
		    "${org}_CentOS_el8_x86_64_BaseOS",
		    "${org}_CentOS_el8_x86_64_AppStream",
		    "${org}_Ceph_el8_x86_64_Ceph_Octopus",
		    "${org}_EPEL_EPEL8_x86_64",
		    "${org}_Foreman_el8_x86_64_TheForeman_${tfmvers}_Client",
		    "${org}_Foreman_el7_x86_64_TheForeman_${tfmvers}_Plugins",
		    "${org}_Katello_el7_x86_64_Katello_${ktlvers}_$pulprepo",
		    "${org}_Puppet_el8_x86_64_Puppet5"
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
		    "${org}_Ceph_el7_x86_64_Ceph_Octopus",
		    "${org}_EPEL_EPEL7_x86_64",
		    "${org}_Foreman_el7_x86_64_TheForeman_${tfmvers}_Client",
		    "${org}_Foreman_el7_x86_64_TheForeman_${tfmvers}_Plugins",
		    "${org}_Katello_el7_x86_64_Katello_${ktlvers}_$pulprepo",
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
