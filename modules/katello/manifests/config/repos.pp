class katello::config::repos {
    $ktlvers = $katello::vars::katello_version
    $plcvers = $katello::vars::pulpcore_version
    $tfmvers = $katello::vars::theforeman_version

# sync plan would all start multiple sync jobs at once, crashing my qnap
# this is most likely due to PULP_CONCURRENCY and /etc/default/pulp_workers no
# longer being used (file used to ship after katello deployment. it's no longer
# there. creating it doesn't seem to have any effect). As such, we'll keep
# sync plans disabled for now...
    katello::define::syncplan {
	[ "Ansible", "CentOS", "Ceph", "Devuan", "OCP", "Products" ]:
	    interval => "weekly",
	    status   => "disabled";
	[ "Debian" ]:
	    interval => "weekly",
	    status   => "disabled";
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
	    source => "https://www.centos.org/keys/RPM-GPG-KEY-CentOS-Official";
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
	"Debian11":
	    source => "https://ftp-master.debian.org/keys/archive-key-11.asc";
	"Debian11-Security":
	    source => "https://ftp-master.debian.org/keys/archive-key-11-security.asc";
	"EPEL7":
	    source => "http://mirrors.ircam.fr/pub/fedora/epel/RPM-GPG-KEY-EPEL-7";
	"EPEL8":
	    source => "http://mirrors.ircam.fr/pub/fedora/epel/RPM-GPG-KEY-EPEL-8";
	"Puppet":
	    source => "https://yum.puppet.com/RPM-GPG-KEY-puppet";
	"TFM-ROR":
	    source => "https://copr-be.cloud.fedoraproject.org/results/@theforeman/tfm-ror51/pubkey.gpg";
	"TheForeman":
	    source => "https://theforeman.org/static/keys/1CC363863DD64AF30638DB79C101586BE0745924.pub";
    }

# although I did define an OCP sync plan, the OCP product only includes
# OKD3 packages - which haven't changed since 3.11 initial release - and
# OCP3 docker images - quite heavy, usually takes 2-3 days for incremental
# sync, over a week for initial clones, ... let's keep the OCP sync plan
# for OCP3 rpms, which as still subject to updates
    each([ "OCP" ]) |$unsyncedproduct| {
	katello::define::product {
	    $unsyncedproduct:
		description => "$unsyncedproduct Repositories";
	}
    }

    each([ "Ansible", "CentOS", "Ceph", "Debian", "Devuan" ]) |$mainproduct| {
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
	"EL8 Ansible":
	    gpgkey    => "Ansible",
	    product   => "Ansible",
	    shortname => "el8 x86_64 Ansible",
	    url       => "https://releases.ansible.com/ansible-runner/rpm/epel-8-x86_64/";

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
	"CentOS8 Extras x86_64":
	    gpgkey    => "CentOS8",
	    product   => "CentOS",
	    shortname => "el8 x86_64 Extras",
	    url       => "http://mirrors.ircam.fr/pub/CentOS/8/extras/x86_64/os/";
	"CentOS8 PowerTools x86_64":
	    gpgkey    => "CentOS8",
	    product   => "CentOS",
	    shortname => "el8 x86_64 PowerTools",
	    url       => "http://mirror.ircam.fr/pub/CentOS/8/PowerTools/x86_64/os/";

## Ceph ##
	"Buster Octopus":
	    debcomps  => [ "main" ],
	    debrels   => [ "buster" ],
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "Buster amd64 Ceph Octopus",
	    type      => "deb",
	    url       => "http://download.ceph.com/debian-octopus/";
	"Buster Pacific":
	    debcomps  => [ "main" ],
	    debrels   => [ "buster" ],
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "Buster amd64 Ceph Pacific",
	    type      => "deb",
	    url       => "http://download.ceph.com/debian-pacific/";
	"Bullseye Pacific":
	    debcomps  => [ "main" ],
	    debrels   => [ "bullseye" ],
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "Bullseye amd64 Ceph Pacific",
	    type      => "deb",
	    url       => "http://download.ceph.com/debian-pacific/";

	"EL7 Octopus noarch":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el7 noarch Ceph Octopus",
	    url       => "http://download.ceph.com/rpm-octopus/el7/noarch/";
	"EL7 Octopus x86_64":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el7 x86_64 Ceph Octopus",
	    url       => "http://download.ceph.com/rpm-octopus/el7/x86_64/";
	"EL8 Octopus noarch":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el8 noarch Ceph Octopus",
	    url       => "http://download.ceph.com/rpm-octopus/el8/noarch/";
	"EL8 Octopus x86_64":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el8 x86_64 Ceph Octopus",
	    url       => "http://download.ceph.com/rpm-octopus/el8/x86_64/";
	"EL8 Pacific noarch":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el8 noarch Ceph Pacific",
	    url       => "http://download.ceph.com/rpm-pacific/el8/noarch/";
	"EL8 Pacific x86_64":
	    gpgkey    => "CephRelease",
	    product   => "Ceph",
	    shortname => "el8 x86_64 Ceph Pacific",
	    url       => "http://download.ceph.com/rpm-pacific/el8/x86_64/";

## Debian ##
#	"Debian Stretch":
#	    debrels   => [ "stretch" ],
#	    gpgkey    => "Debian9",
#	    product   => "Debian",
#	    shortname => "Debian9",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Stretch Updates":
#	    debrels   => [ "stretch-updates" ],
#	    gpgkey    => "Debian9",
#	    product   => "Debian",
#	    shortname => "Debian9 Updates",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Stretch Backports":
#	    debrels   => [ "stretch-backports" ],
#	    product   => "Debian",
#	    shortname => "Debian9 Backports",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Stretch Security":
#	    debrels   => [ "stretch/updates" ],
#	    gpgkey    => "Debian9-Security",
#	    product   => "Debian",
#	    shortname => "Debian9 Security",
#	    type      => "deb",
#	    url       => "http://security.debian.org/";
#	"Debian Buster":
#	    debrels   => [ "buster" ],
#	    gpgkey    => "Debian10",
#	    product   => "Debian",
#	    shortname => "Debian10",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Buster Updates":
#	    debrels   => [ "buster-updates" ],
#	    gpgkey    => "Debian10",
#	    product   => "Debian",
#	    shortname => "Debian10 Updates",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Buster Backports":
#	    debrels   => [ "buster-backports" ],
#	    product   => "Debian",
#	    shortname => "Debian10 Backports",
#	    type      => "deb",
#	    url       => "http://ftp.debian.org/debian/";
#	"Debian Buster Security":
#	    debrels   => [ "buster/updates" ],
#	    gpgkey    => "Debian10-Security",
#	    product   => "Debian",
#	    shortname => "Debian10 Security",
#	    type      => "deb",
#	    url       => "http://security.debian.org/";
	"Debian Bullseye":
	    debrels   => [ "bullseye" ],
	    gpgkey    => "Debian11",
	    product   => "Debian",
	    shortname => "Debian11",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Bullseye Updates":
	    debrels   => [ "bullseye-updates" ],
	    gpgkey    => "Debian11",
	    product   => "Debian",
	    shortname => "Debian11 Updates",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Bullseye Backports":
	    debrels   => [ "bullseye-backports" ],
	    product   => "Debian",
	    shortname => "Debian11 Backports",
	    type      => "deb",
	    url       => "http://ftp.debian.org/debian/";
	"Debian Bullseye Security":
	    debrels   => [ "bullseye-security" ],
	    gpgkey    => "Debian11-Security",
	    product   => "Debian",
	    shortname => "Debian11 Security",
	    type      => "deb",
	    url       => "http://security.debian.org/";

## Devuan ##
#	"Devuan Jessie":
#	    debrels   => [ "jessie" ],
#	    product   => "Devuan",
#	    shortname => "Devuan Jessie",
#	    type      => "deb",
#	    url       => "http://deb.devuan.org/merged/";
#	"Devuan Jessie Security":
#	    debrels   => [ "jessie-security" ],
#	    product   => "Devuan",
#	    shortname => "Devuan Jessie Security",
#	    type      => "deb",
#	    url       => "http://deb.devuan.org/merged/";
#	"Devuan Ascii":
#	    debrels   => [ "ascii" ],
#	    product   => "Devuan",
#	    shortname => "Devuan Ascii",
#	    type      => "deb",
#	    url       => "http://deb.devuan.org/merged/";
#	"Devuan Ascii Security":
#	    debrels   => [ "ascii-security" ],
#	    product   => "Devuan",
#	    shortname => "Devuan Ascii Security",
#	    type      => "deb",
#	    url       => "http://deb.devuan.org/merged/";
#	"Devuan Ascii Updates":
#	    debrels   => [ "ascii-updates" ],
#	    product   => "Devuan",
#	    shortname => "Devuan Ascii Updates",
#	    type      => "deb",
#	    url       => "http://deb.devuan.org/merged/";

## EPEL ##
	"EPEL7 x86_64":
	    gpgkey    => "EPEL7",
	    mirror    => false,
	    product   => "EPEL",
	    shortname => "EPEL7 x86_64",
	    url       => "http://mirrors.ircam.fr/pub/fedora/epel/7/x86_64/";
	"EPEL8 x86_64":
	    gpgkey    => "EPEL8",
	    mirror    => false,
	    product   => "EPEL",
	    shortname => "EPEL8 x86_64",
	    url       => "http://mirrors.ircam.fr/pub/fedora/epel/8/Everything/x86_64/";
	"EPEL8 Modular x86_64":
	    gpgkey    => "EPEL8",
	    product   => "EPEL",
	    shortname => "EPEL8 Modular x86_64",
	    url       => "http://mirrors.ircam.fr/pub/fedora/epel/8/Modular/x86_64/";

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
	"EL8 TheForeman $tfmvers Client":
	    gpgkey    => "TheForeman",
	    product   => "Foreman",
	    shortname => "el8 x86_64 TheForeman $tfmvers Client",
	    url       => "https://yum.theforeman.org/client/$tfmvers/el8/x86_64/";
	"EL8 TheForeman $tfmvers Plugins":
	    product   => "Foreman",
	    shortname => "el8 x86_64 TheForeman $tfmvers Plugins",
	    url       => "https://yum.theforeman.org/plugins/$tfmvers/el8/x86_64/";

## Katello ##
	"EL7 Katello $ktlvers":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $ktlvers",
	    url       => "https://yum.theforeman.org/katello/$ktlvers/katello/el7/x86_64/";
	"EL7 Katello $ktlvers Candlepin":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $ktlvers Candlepin",
	    url       => "https://yum.theforeman.org/katello/$ktlvers/candlepin/el7/x86_64/";
	"EL8 Katello $ktlvers":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el8 x86_64 Katello $ktlvers",
	    url       => "https://yum.theforeman.org/katello/$ktlvers/katello/el8/x86_64/";
	"EL8 Katello $ktlvers Candlepin":
	    gpgkey    => "TheForeman",
	    product   => "Katello",
	    shortname => "el8 x86_64 Katello $ktlvers Candlepin",
	    url       => "https://yum.theforeman.org/katello/$ktlvers/candlepin/el8/x86_64/";

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
	    url       => "https://yum.puppetlabs.com/puppet5/el/7/x86_64/";
	"EL7 Puppet6":
	    gpgkey    => "Puppet",
	    product   => "Puppet",
	    shortname => "el7 x86_64 Puppet6",
	    url       => "https://yum.puppetlabs.com/puppet6/el/7/x86_64/";
	"EL8 Puppet6":
	    gpgkey    => "Puppet",
	    product   => "Puppet",
	    shortname => "el8 x86_64 Puppet6",
	    url       => "https://yum.puppetlabs.com/puppet6/el/8/x86_64/";
    }

    katello::define::repository {
	"EL7 Katello $plcvers Pulpcore":
	    product   => "Katello",
	    shortname => "el7 x86_64 Katello $plcvers Pulpcore",
	    url       => "https://yum.theforeman.org/pulpcore/$plcvers/el7/x86_64/";
	"EL8 Katello $plcvers Pulpcore":
	    product   => "Katello",
	    shortname => "el8 x86_64 Katello $plcvers Pulpcore",
	    url       => "https://yum.theforeman.org/pulpcore/$plcvers/el8/x86_64/";
    }
}
