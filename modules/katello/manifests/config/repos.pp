class katello::config::repos {
    $ktlvers = $katello::vars::katello_version
    $plpvers = $katello::vars::pulp_version
    $tfmvers = $katello::vars::theforeman_version

    katello::define::syncplan {
	[ "Ansible", "CentOS", "Ceph", "Debian", "Devuan", "OCP", "Products" ]:
	    interval => "weekly";
    }

    katello::define::gpgkey {
	"Ansible":
	    source => "https://releases.ansible.com/keys/RPM-GPG-KEY-ansible-release.pub";
	"CentOS-SIG-PaaS":
	    source => "https://raw.githubusercontent.com/openshift/openshift-ansible/master/images/installer/origin-extra-root/etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-SIG-PaaS";
	"CentOS7":
	    source => "http://mirrors.ircam.fr/pub/CentOS/RPM-GPG-KEY-CentOS-7";
	"CentOS7-SCL":
	    source => "https://raw.githubusercontent.com/sclorg/centos-release-scl/master/centos-release-scl/RPM-GPG-KEY-CentOS-SIG-SCLo";
	"CentOS8":
	    source => "http://mirror.oss.ou.edu/centos/RPM-GPG-KEY-CentOS-Official";
	"CephRelease":
	    source => "http://download.ceph.com/keys/release.asc";
	"Debian8":
	    source => "https://ftp-master.debian.org/keys/archive-key-8.asc";
	"Debian8-Security":
	    source => "https://ftp-master.debian.org/keys/archive-key-8-security.asc";
	"Debian9":
	    source => "https://ftp-master.debian.org/keys/archive-key-9.asc";
	"Debian9-Security":
	    source => "https://ftp-master.debian.org/keys/archive-key-9-security.asc";
	"Debian10":
	    source => "https://ftp-master.debian.org/keys/archive-key-10.asc";
	"Debian10-Security":
	    source => "https://ftp-master.debian.org/keys/archive-key-10-security.asc";
	"EPEL7":
	    source => "http://mirrors.ircam.fr/pub/fedora/epel/RPM-GPG-KEY-EPEL-7";
	"EPEL8":
	    source => "http://mirrors.ircam.fr/pub/fedora/epel/RPM-GPG-KEY-EPEL-8";
	"Puppet":
	    source => "https://yum.puppet.com/RPM-GPG-KEY-puppet";
	"TFM-ROR":
	    source => "https://copr-be.cloud.fedoraproject.org/results/@theforeman/tfm-ror51/pubkey.gpg";
	"TheForeman":
	    source => "https://yum.theforeman.org/rails/foreman-$tfmvers/RPM-GPG-KEY-foreman";
    }

    each([ "Ansible", "CentOS", "Ceph", "Debian", "Devuan", "OCP" ]) |$mainproduct| {
	katello::define::product {
	    $mainproduct:
		description => "$mainproduct Repositories",
		syncplan    => $mainproduct;
	}
    }

    each([ "EPEL", "Foreman", "Katello", "Puppet" ]) |$product| {
	katello::define::product {
	    $product:
		description => "$product Repositories",
		syncplan    => "Products";
	}
    }

    katello::define::repository {
## Ansible ##
	"EL7 Ansible":
	    gpgkey    => "Ansible",
	    product   => "Ansible",
	    shortname => "el7 x86_64 Ansible",
	    url       => "https://releases.ansible.com/ansible-runner/rpm/epel-7-x86_64/";

## CentOS ##
	"CentOS7 Base x86_64":
	    gpgkey    => "CentOS7",
	    product   => "CentOS",
	    shortname => "el7 x86_64 Base",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/7/os/x86_64/";
	"CentOS7 Extras x86_64":
	    gpgkey    => "CentOS7",
	    product   => "CentOS",
	    shortname => "el7 x86_64 Extras",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/7/extras/x86_64/";
	"CentOS7 Updates x86_64":
	    gpgkey    => "CentOS7",
	    product   => "CentOS",
	    shortname => "el7 x86_64 Updates",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/7/updates/x86_64/";
	"CentOS7 SCL x86_64":
	    gpgkey    => "CentOS7-SCL",
	    product   => "CentOS",
	    shortname => "el7 x86_64 SCL",
	    url       => "http://mirror.centos.org/centos/7/sclo/x86_64/sclo/";
	"CentOS8 AppStream x86_64":
	    gpgkey    => "CentOS8",
	    product   => "CentOS",
	    shortname => "el8 x86_64 AppStream",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/8/AppStream/x86_64/os/";
	"CentOS8 BaseOS x86_64":
	    gpgkey    => "CentOS8",
	    product   => "CentOS",
	    shortname => "el8 x86_64 BaseOS",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/8/BaseOS/x86_64/os/";

## Ceph ##
	"Bionic Nautilus":
	    debcomps  => [ "main" ],
	    debrels   => [ "bionic" ],
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "Bionic amd64 Ceph Nautilus",
	    type      => "deb",
	    url       => "http://download.ceph.com/debian-nautilus/";
	"EL7 Nautilus":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el7 x86_64 Ceph Nautilus",
	    url       => "http://download.ceph.com/rpm-nautilus/el7/x86_64/";
	"Xenial Nautilus":
	    debcomps  => [ "main" ],
	    debrels   => [ "xenial" ],
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "Xenial amd64 Ceph Nautilus",
	    type      => "deb",
	    url       => "http://download.ceph.com/debian-nautilus/";

## Debian ##
	"Debian Stretch":
	    debrels   => [ "stretch", "stretch-updates" ],
	    gpgkey    => "Debian9",
	    product   => "Debian",
	    shortname => "Debian9",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Stretch Backports":
	    debrels   => [ "stretch-backports" ],
	    product   => "Debian",
	    shortname => "Debian9 Backports",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Stretch Security":
	    debrels   => [ "stretch/updates" ],
	    gpgkey    => "Debian9-Security",
	    product   => "Debian",
	    shortname => "Debian9 Security",
	    type      => "deb",
	    url       => "http://security.debian.org/";
	"Debian Buster":
	    debrels   => [ "buster", "buster-updates" ],
	    gpgkey    => "Debian10",
	    product   => "Debian",
	    shortname => "Debian10",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Buster Backports":
	    debrels   => [ "buster-backports" ],
	    product   => "Debian",
	    shortname => "Debian10 Backports",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Buster Security":
	    debrels   => [ "buster/updates" ],
	    gpgkey    => "Debian10-Security",
	    product   => "Debian",
	    shortname => "Debian10 Security",
	    type      => "deb",
	    url       => "http://security.debian.org/";

## Devuan ##
	"Devuan Jessie":
	    debrels   => [ "jessie", "jessie-security" ],
	    product   => "Devuan",
	    shortname => "Devuan Jessie",
	    type      => "deb",
	    url       => "http://deb.devuan.org/merged/";
	"Devuan Ascii":
	    debrels   => [ "ascii", "ascii-security", "ascii-updates" ],
	    product   => "Devuan",
	    shortname => "Devuan Ascii",
	    type      => "deb",
	    url       => "http://deb.devuan.org/merged/";

## EPEL ##
	"EPEL7 x86_64":
	    gpgkey    => "EPEL7",
	    product   => "EPEL",
	    shortname => "EPEL7 x86_64",
	    url       => "http://mirrors.ircam.fr/pub/fedora/epel/7/x86_64/";
	"EPEL8 x86_64":
	    gpgkey    => "EPEL8",
	    product   => "EPEL",
	    shortname => "EPEL8 x86_64",
	    url       => "http://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/";

## Foreman ##
	"EL7 TheForeman $tfmvers":
	    gpgkey    => "TheForeman",
	    product   => "Foreman",
	    shortname => "el7 x86_64 TheForeman $tfmvers",
	    url       => "https://yum.theforeman.org/releases/$tfmvers/el7/x86_64/";
	"EL7 TheForeman $tfmvers Client":
	    gpgkey    => "TheForeman",
	    product   => "Foreman",
	    shortname => "el7 x86_64 TheForeman $tfmvers Client",
	    url       => "https://yum.theforeman.org/client/$tfmvers/el7/x86_64/";
	"EL7 TheForeman $tfmvers Plugins":
	    product   => "Foreman",
	    shortname => "el7 x86_64 TheForeman $tfmvers Plugins",
	    url       => "https://yum.theforeman.org/plugins/$tfmvers/el7/x86_64/";
	"EL7 TheForeman $tfmvers Rails":
	    gpgkey    => "TheForeman",
	    product   => "Foreman",
	    shortname => "el7 x86_64 TheForeman $tfmvers Rails",
	    url       => "https://yum.theforeman.org/rails/foreman-$tfmvers/el7/x86_64/";

## Katello ##
	"EL7 Katello $ktlvers":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $ktlvers",
	    url       => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/katello/el7/x86_64/";
	"EL7 Katello $ktlvers Candlepin":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $ktlvers Candlepin",
	    url       => "https://fedorapeople.org/groups/katello/releases/yum/$ktlvers/candlepin/el7/x86_64/";
	"EL7 Katello $ktlvers Pulp":
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $ktlvers Pulp",
	    url       => "https://repos.fedorapeople.org/repos/pulp/pulp/stable/$plpvers/7/x86_64/";

## OKD3 ##
	"EL7 OKD 3.11":
	    gpgkey    => "CentOS-SIG-PaaS",
	    product   => "OCP",
	    shortname => "el7 x86_64 OKD 3.11",
	    url       => "http://mirror.centos.org/centos/7/paas/x86_64/openshift-origin311/";

## Puppet ##
	"EL7 Puppet5":
	    gpgkey    => "Puppet",
	    product   => "Puppet",
	    shortname => "el7 x86_64 Puppet5",
	    url       => "http://yum.puppetlabs.com/puppet5/el/7/SRPMS";
    }
}
