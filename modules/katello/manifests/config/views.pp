class katello::config::views {
    $ktlvers = $katello::vars::katello_version
    $tfmvers = $katello::vars::theforeman_version

    katello::define::lifecycleenvironment {
	"Prod":
	    parent => "Dev";
	"Dev":
    }

    if ($tfmvers == "1.24" or $tfmvers == 1.24) {
	$pulprepo = "Pulp"
    } else { $pulprepo = "Pulpcore" }

    katello::define::contentview {
	"CV-Ansible-el7":
	    content   => [ { product    => "Ansible",
			     rname      => "EL7 Ansible",
			     repository => "el7 x86_64 Ansible" } ];
	"CV-Ceph-el7":
	    content   => [ { product    => "Ceph",
			     rname      => "EL7 Nautilus",
			     repository => "el7 x86_64 Ceph Nautilus" } ];
	"CV-EPEL-el7":
	    content   => [ { product    => "EPEL",
			     rname      => "EPEL7 x86_64",
			     repository => "EPEL7 x86_64" } ];
	"CV-EPEL-el8":
	    content   => [ { product    => "EPEL",
			     rname      => "EPEL8 x86_64",
			     repository => "EPEL8 x86_64" } ];
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
		      rname      => "CentOS8 AppStream x86_64",
		      repository => "el8 x86_64 AppStream" }
		];
	"CV-base-debian10":
	    content   =>
		[
		    { product    => "Debian",
		      rname      => "Debian Buster",
		      repository => "Debian10" },
		    { product    => "Debian",
		      rname      => "Debian Buster Backports",
		      repository => "Debian10 Backports" } ,
		    { product    => "Debian",
		      rname      => "Debian Buster Security",
		      repository => "Debian10 Security" }
		],
	    dopublish => false;
	"CV-base-debian9":
	    content   =>
		[
		    { product    => "Debian",
		      rname      => "Debian Stretch",
		      repository => "Debian9" },
		    { product    => "Debian",
		      rname      => "Debian Stretch Backports",
		      repository => "Debian9 Backports" } ,
		    { product    => "Debian",
		      rname      => "Debian Stretch Security",
		      repository => "Debian9 Security" }
		],
	    dopublish => false;
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
		      rname      => "EL7 Katello $ktlvers $pulprepo",
		      repository => "el7 x86_64 Katello $ktlvers $pulprepo" },
		    { product    => "Puppet",
		      rname      => "EL7 Puppet5",
		      repository => "el7 x86_64 Puppet5" }
		];

	"CCV-Ceph-el7":
	    composite => true,
	    content   =>
		[
		    "CV-Ceph-el7", "CV-EPEL-el7",
		    "CV-base-centos7", "CV-katello-client-el7"
		],
	    tolce     => [ "Dev", "Prod" ];
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
	    content   => [ "CV-base-centos8", "CV-EPEL-el8", "CV-katello-client-el7" ],
	    tolce     => [ "Dev", "Prod" ];
    }
}
