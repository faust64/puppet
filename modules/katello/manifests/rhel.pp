class katello::rhel {
    include apache::rhel

    $ktlvers = $katello::vars::katello_version
    $plpvers = $katello::vars::pulp_version
    $pptvers = $katello::vars::puppet_version
    $tfmvers = $katello::vars::theforeman_version

    yum::define::repo {
	"ansible-runner":
	    baseurl => "https://releases.ansible.com/ansible-runner/rpm/epel-${operatingsystemmajrelease}-x86_64/",
	    descr   => "Ansible runner el$operatingsystemmajrelease",
	    gpgkey  => "https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub",
	    notify  => Exec["Update System prior Katello deployment"];
	"foreman-client":
	    baseurl => "https://yum.theforeman.org/client/$tfmvers/el$operatingsystemmajrelease/x86_64/",
	    descr   => "TheForeman Client $tfmvers - el$operatingsystemmajrelease",
	    notify  => Exec["Update System prior Katello deployment"];
	"foreman-plugins":
	    baseurl => "https://yum.theforeman.org/plugins/$tfmvers/el$operatingsystemmajrelease/x86_64/",
	    descr   => "TheForeman Plugins $tfmvers - el$operatingsystemmajrelease",
	    notify  => Exec["Update System prior Katello deployment"];
	"foreman":
	    baseurl => "https://yum.theforeman.org/releases/$tfmvers/el$operatingsystemmajrelease/x86_64/",
	    descr   => "TheForeman Main $tfmvers - el$operatingsystemmajrelease",
	    gpgkey  => "https://yum.theforeman.org/releases/$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"katello":
	    baseurl => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/katello/el$operatingsystemmajrelease/x86_64/",
	    descr   => "Katello Main $ktlvers - el$operatingsystemmajrelease",
	    gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"katello-candlepin":
	    baseurl => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/candlepin/el$operatingsystemmajrelease/x86_64/",
	    descr   => "Katello Candlepin $ktlvers - el$operatingsystemmajrelease",
	    gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"puppet$pptvers":
	    baseurl => "http://yum.puppetlabs.com/puppet$pptvers/el/$operatingsystemmajrelease/SRPMS",
	    descr   => "Puppet$pptvers - el$operatingsystemmajrelease",
	    gpgkey  => "https://yum.puppet.com/RPM-GPG-KEY-puppet",
	    notify  => Exec["Update System prior Katello deployment"];
    }

    if ($tfmvers == "1.24" or $tfmvers == 1.24) {
	yum::define::repo {
	    "foreman-rails":
		baseurl => "https://yum.theforeman.org/rails/foreman-$tfmvers/el$operatingsystemmajrelease/x86_64/",
		descr   => "TheForeman Rails $tfmvers - el$operatingsystemmajrelease",
		gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
		notify  => Exec["Update System prior Katello deployment"];
	    "katello-pulp":
		baseurl => "https://repos.fedorapeople.org/repos/pulp/pulp/stable/$plpvers/$operatingsystemmajrelease/x86_64/",
		descr   => "Katello Pulp $ktlvers - el$operatingsystemmajrelease",
		notify  => Exec["Update System prior Katello deployment"];
	}
    } else {
	yum::define::repo {
	    "foreman-rails":
		ensure  => "absent";
	    "katello-pulp":
		ensure  => "absent";
	    "katello-pulpcore":
		baseurl => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/pulpcore/el$operatingsystemmajrelease/x86_64/",
		descr   => "Katello Pulpcore $ktlvers - el$operatingsystemmajrelease",
		notify  => Exec["Update System prior Katello deployment"];
	}

	Yum::Define::Repo["katello-pulpcore"]
#	    -> Common::Define::Package["foreman-release-scl"]
    }

    common::define::package {
	"katello":
	    require => Exec["Update System prior Katello deployment"];
#	"foreman-release-scl":
#	    require =>
#		[
#		    Yum::Define::Repo["ansible-runner"],
#		    Yum::Define::Repo["epel"],
#		    Yum::Define::Repo["foreman"],
#		    Yum::Define::Repo["foreman-client"],
#		    Yum::Define::Repo["foreman-plugins"],
#		    Yum::Define::Repo["foreman-rails"],
#		    Yum::Define::Repo["katello"],
#		    Yum::Define::Repo["katello-candlepin"],
#		    Yum::Define::Repo["katello-pulp"],
#		    Yum::Define::Repo["puppet$pptvers"]
#		];
    }
}
