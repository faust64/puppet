class katello::rhel {
    include apache::rhel

    $ktlvers = $katello::vars::katello_version
    $plpvers = $katello::vars::pulp_version
    $tfmvers = $katello::vars::theforeman_version

    yum::define::repo {
	"ansible-runner":
	    baseurl => "https://releases.ansible.com/ansible-runner/rpm/epel-7-x86_64/",
	    descr   => "Ansible runner",
	    gpgkey  => "https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub",
	    notify  => Exec["Update System prior Katello deployment"];
	"theforeman-client":
	    baseurl => "https://yum.theforeman.org/client/$tfmvers/el7/x86_64/",
	    descr   => "TheForeman Client $tfmvers - el7",
	    notify  => Exec["Update System prior Katello deployment"];
	"theforeman-plugins":
	    baseurl => "https://yum.theforeman.org/plugins/$tfmvers/el7/x86_64/",
	    descr   => "TheForeman Plugins $tfmvers - el7",
	    notify  => Exec["Update System prior Katello deployment"];
	"theforeman-rails":
	    baseurl => "https://yum.theforeman.org/rails/foreman-$tfmvers/el7/x86_64/",
	    descr   => "TheForeman Rails $tfmvers - el7",
	    gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"theforeman":
	    baseurl => "https://yum.theforeman.org/releases/$tfmvers/el7/x86_64/",
	    descr   => "TheForeman Main $tfmvers - el7",
	    gpgkey  => "https://yum.theforeman.org/releases/$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"katello":
	    baseurl => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/katello/el7/x86_64/",
	    descr   => "Katello Main $ktlvers - el7",
	    gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"katello-candlepin":
	    baseurl => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/candlepin/el7/x86_64/",
	    descr   => "Katello Candlepin $ktlvers - el7",
	    gpgkey  => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman",
	    notify  => Exec["Update System prior Katello deployment"];
	"katello-pulp":
	    baseurl => "https://repos.fedorapeople.org/repos/pulp/pulp/stable/$plpvers/7/x86_64/",
	    descr   => "Katello Pulp $ktlvers - el7",
	    notify  => Exec["Update System prior Katello deployment"];
	"puppet5":
	    baseurl => "http://yum.puppetlabs.com/puppet5/el/7/SRPMS",
	    descr   => "Puppet5 - el7",
	    gpgkey  => "https://yum.puppet.com/RPM-GPG-KEY-puppet",
	    notify  => Exec["Update System prior Katello deployment"];
    }

    common::define::package {
	"katello":
	    require => Exec["Update System prior Katello deployment"];
	"foreman-release-scl":
	    require =>
		[
		    Yum::Define::Repo["ansible-runner"],
		    Yum::Define::Repo["epel"],
		    Yum::Define::Repo["katello"],
		    Yum::Define::Repo["katello-candlepin"],
		    Yum::Define::Repo["katello-pulp"],
		    Yum::Define::Repo["puppet5"],
		    Yum::Define::Repo["theforeman"],
		    Yum::Define::Repo["theforeman-client"],
		    Yum::Define::Repo["theforeman-plugins"],
		    Yum::Define::Repo["theforeman-rails"]
		];
    }
}
