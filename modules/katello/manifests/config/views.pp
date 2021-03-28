class katello::config::views {
    $ktlvers = $katello::vars::katello_version
    $plpvers = $katello::vars::pulpcore_version
    $pptvers = $katello::vars::puppet_version
    $tfmvers = $katello::vars::theforeman_version

    katello::define::lifecycleenvironment {
	"Prod":
	    parent => "Dev";
	"Dev":
    }

    katello::define::contentview {
	"CV-Ansible-el7":
	    content   => [ { product    => "Ansible",
			     rname      => "EL7 Ansible",
			     repository => "el7 x86_64 Ansible" } ];
	"CV-Ansible-el8":
	    content   => [ { product    => "Ansible",
			     rname      => "EL8 Ansible",
			     repository => "el8 x86_64 Ansible" } ];
	"CV-Ceph-el7":
	    content   => [ { product    => "Ceph",
			     rname      => "EL7 Octopus x86_64",
			     repository => "el7 x86_64 Ceph Octopus" },
			   { product    => "Ceph",
			     rname      => "EL7 Octopus noarch",
			     repository => "el7 noarch Ceph Octopus" } ];
	"CV-Ceph-el8":
	    content   => [ { product    => "Ceph",
			     rname      => "EL8 Octopus x86_64",
			     repository => "el8 x86_64 Ceph Octopus" },
			   { product    => "Ceph",
			     rname      => "EL8 Octopus noarch",
			     repository => "el8 noarch Ceph Octopus" } ];
	"CV-Ceph-deb10":
	    content   => [ { product    => "Ceph",
			     rname      => "Buster Octopus",
			     repository => "Buster amd64 Ceph Octopus" } ];
	"CV-EPEL-el7":
	    content   => [ { product    => "EPEL",
			     rname      => "EPEL7 x86_64",
			     repository => "EPEL7 x86_64" } ];
	"CV-EPEL-el8":
	    content   => [ { product    => "EPEL",
			     rname      => "EPEL8 x86_64",
			     repository => "EPEL8 x86_64" },
			   { product    => "EPEL",
			     rname      => "EPEL8 Modular x86_64",
			     repository => "EPEL8 Modular x86_64" }
			 ];
	"CV-OKD-el7":
	    content   => [ { product    => "OCP",
			     rname      => "EL7 OKD 3.11",
			     repository => "el7 x86_64 OKD 3.11" } ];
	"CV-base-centos7":
	    content   =>
		[
		    { product    => "CentOS",
		      rname      => "CentOS7 Base x86_64",
		      repository => "el7 x86_64 Base" },
		    { product    => "CentOS",
		      rname      => "CentOS7 Extras x86_64",
		      repository => "el7 x86_64 Extras" } ,
		    { product    => "CentOS",
		      rname      => "CentOS7 Updates x86_64",
		      repository => "el7 x86_64 Updates" },
		    { product    => "CentOS",
		      rname      => "CentOS7 SCL x86_64",
		      repository => "el7 x86_64 SCL" }
		];
	"CV-base-centos8":
	    content   =>
		[
		    { product    => "CentOS",
		      rname      => "CentOS8 BaseOS x86_64",
		      repository => "el8 x86_64 BaseOS" },
		    { product    => "CentOS",
		      rname      => "CentOS8 Extras x86_64",
		      repository => "el8 x86_64 Extras" },
		    { product    => "CentOS",
		      rname      => "CentOS8 AppStream x86_64",
		      repository => "el8 x86_64 AppStream" },
		    { product    => "CentOS",
		      rname      => "CentOS8 PowerTools x86_64",
		      repository => "el8 x86_64 PowerTools" }
		];
#	"CV-base-debian10":
#	    content   =>
#		[
#		    { product    => "Debian",
#		      rname      => "Debian Buster",
#		      repository => "Debian10" },
#		    { product    => "Debian",
#		      rname      => "Debian Buster Updates",
#		      repository => "Debian10" },
#		    { product    => "Debian",
#		      rname      => "Debian Buster Backports",
#		      repository => "Debian10 Backports" } ,
#		    { product    => "Debian",
#		      rname      => "Debian Buster Security",
#		      repository => "Debian10 Security" }
#		],
#	    dopublish => false;
#	"CV-base-debian9":
#	    content   =>
#		[
#		    { product    => "Debian",
#		      rname      => "Debian Stretch",
#		      repository => "Debian9" },
#		    { product    => "Debian",
#		      rname      => "Debian Stretch Updates",
#		      repository => "Debian9" },
#		    { product    => "Debian",
#		      rname      => "Debian Stretch Backports",
#		      repository => "Debian9 Backports" } ,
#		    { product    => "Debian",
#		      rname      => "Debian Stretch Security",
#		      repository => "Debian9 Security" }
#		],
#	    dopublish => false;
	"CV-katello-client-el7":
	    content   =>
		[
		    { product    => "Foreman",
		      rname      => "EL7 TheForeman $tfmvers Client",
		      repository => "el7 x86_64 TheForeman $tfmvers Client" },
		    { product    => "Foreman",
		      rname      => "EL7 TheForeman $tfmvers Plugins",
		      repository => "el7 x86_64 TheForeman $tfmvers Plugins" },
		    { product    => "Katello",
		      rname      => "EL7 Katello $plpvers Pulpcore",
		      repository => "el7 x86_64 Katello $plpvers Pulpcore" },
		    { product    => "Puppet",
		      rname      => "EL7 Puppet$pptvers",
		      repository => "el7 x86_64 Puppet$pptvers" }
		];
	"CV-katello-client-el8":
	    content   =>
		[
		    { product    => "Foreman",
		      rname      => "EL8 TheForeman $tfmvers Client",
		      repository => "el8 x86_64 TheForeman $tfmvers Client" },
		    { product    => "Foreman",
		      rname      => "EL8 TheForeman $tfmvers Plugins",
		      repository => "el8 x86_64 TheForeman $tfmvers Plugins" },
		    { product    => "Katello",
		      rname      => "EL8 Katello $plpvers Pulpcore",
		      repository => "el8 x86_64 Katello $plpvers Pulpcore" },
		    { product    => "Puppet",
		      rname      => "EL8 Puppet$pptvers",
		      repository => "el8 x86_64 Puppet$pptvers" }
		];

	"CCV-Ceph-el7":
	    composite => true,
	    content   =>
		[
		    "CV-Ceph-el7", "CV-EPEL-el7",
		    "CV-base-centos7", "CV-katello-client-el7"
		],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-Ceph-el8":
	    composite => true,
	    content   =>
		[
		    "CV-Ceph-el8", "CV-EPEL-el8",
		    "CV-base-centos8", "CV-katello-client-el8"
		],
	    tolce     => [ "Dev", "Prod" ];
#	"CCV-Ceph-deb10":
#	    composite => true,
#	    content   => [ "CV-Ceph-deb10", "CV-base-debian10" ],
#	    tolce     => [ "Dev", "Prod" ];
	"CCV-OKD-el7":
	    composite => true,
	    content   =>
		[
		    "CV-Ceph-el7", "CV-OKD-el7",
		    "CV-EPEL-el7", "CV-base-centos7",
		    "CV-katello-client-el7"
		],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-centos7":
	    composite => true,
	    content   => [ "CV-base-centos7", "CV-EPEL-el7", "CV-katello-client-el7" ],
	    tolce     => [ "Dev", "Prod" ];
	"CCV-centos8":
	    composite => true,
	    content   => [ "CV-base-centos8", "CV-EPEL-el8", "CV-katello-client-el8" ],
	    tolce     => [ "Dev", "Prod" ];
    }
}
