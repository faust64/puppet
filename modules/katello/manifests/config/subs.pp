class katello::config::subs {
    $ktlvers = $katello::vars::katello_version
    $org     = $katello::vars::katello_org
    $orgorig = $katello::vars::katello_org_orig
    $plcvers = $katello::vars::pulpcore_version
    $pptvers = $katello::vars::puppet_version
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
	    medium       => "CentOS 7 mirror",
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
	    contentview => "CCV-Ceph-el8",
	    hasrepos    =>
		[
		    "${orgorig}_CentOS_el8_x86_64_AppStream",
		    "${orgorig}_CentOS_el8_x86_64_BaseOS",
		    "${orgorig}_CentOS_el8_x86_64_Extras",
		    "${orgorig}_CentOS_el8_x86_64_PowerTools",
		    "${orgorig}_Ceph_el8_x86_64_Ceph_Octopus",
		    "${orgorig}_EPEL_EPEL8_x86_64",
		    "${orgorig}_EPEL_EPEL8_Modular_x86_64",
		    "${orgorig}_Foreman_el8_x86_64_TheForeman_${tfmvers}_Client",
		    "${orgorig}_Foreman_el8_x86_64_TheForeman_${tfmvers}_Plugins",
		    "${orgorig}_Katello_el8_x86_64_Katello_${plcvers}_Pulpcore",
		    "${orgorig}_Puppet_el8_x86_64_Puppet$pptvers"
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
		    "${orgorig}_OCP_el7_x86_64_OKD_3_11",
		    "${orgorig}_CentOS_el7_x86_64_Base",
		    "${orgorig}_CentOS_el7_x86_64_Extras",
		    "${orgorig}_CentOS_el7_x86_64_SCL",
		    "${orgorig}_CentOS_el7_x86_64_Updates",
		    "${orgorig}_Ceph_el7_x86_64_Ceph_Octopus",
		    "${orgorig}_EPEL_EPEL7_x86_64",
		    "${orgorig}_Foreman_el7_x86_64_TheForeman_${tfmvers}_Client",
		    "${orgorig}_Foreman_el7_x86_64_TheForeman_${tfmvers}_Plugins",
		    "${orgorig}_Katello_el7_x86_64_Katello_${plcvers}_Pulpcore",
		    "${orgorig}_Puppet_el7_x86_64_Puppet$pptvers"
		],
	    lce         => "Prod";
    }

    katello::define::policy {
	"Default CentOS7":
	    hostgroups => [ "Ceph", "OKD" ],
	    policy     => "CentOS 7 DS 1.2",
	    profile    => "xccdf_org.ssgproject.content_profile_standard";
	"Default CentOS8":
	    policy     => "CentOS 8 DS 1.2",
	    profile    => "xccdf_org.ssgproject.content_profile_standard";
	"PCI-DSS CentOS7":
	    policy     => "CentOS 7 DS 1.2",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
	"PCI-DSS CentOS8":
	    policy     => "CentOS 8 DS 1.2",
	    profile    => "xccdf_org.ssgproject.content_profile_pci-dss";
    }
}
