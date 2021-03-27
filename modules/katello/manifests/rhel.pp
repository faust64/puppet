class katello::rhel {
    include apache::rhel

# yum module install pki-core
    $ktlvers = $katello::vars::katello_version
    $plpvers = $katello::vars::pulp_version
    $pptvers = $katello::vars::puppet_version
    $tfmvers = $katello::vars::theforeman_version

    common::define::package {
	[
	    "https://yum.puppet.com/puppet$pptvers-release-el-$operatingsystemmajrelease.noarch.rpm",
	    "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/katello/el$operatingsystemmajrelease/x86_64/katello-repos-latest.rpm",
	    "https://yum.theforeman.org/releases/$tfmvers/el$operatingsystemmajrelease/x86_64/foreman-release.rpm",
	    "epel-release"
	]:
    }
    yum::define::repo {
	"ansible-runner":
	    baseurl => "https://releases.ansible.com/ansible-runner/rpm/epel-${operatingsystemmajrelease}-x86_64/",
	    descr   => "Ansible runner el$operatingsystemmajrelease",
	    gpgkey  => "https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub",
	    notify  => Exec["Update System prior Katello deployment"];
#	"foreman-client":
#	    baseurl => "https://yum.theforeman.org/client/$tfmvers/el$operatingsystemmajrelease/x86_64/",
#	    descr   => "TheForeman Client $tfmvers - el$operatingsystemmajrelease",
#	    notify  => Exec["Update System prior Katello deployment"];
    }

    common::define::package {
	"katello":
	    require => Exec["Update System prior Katello deployment"];
    }
}
