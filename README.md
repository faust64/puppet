puppet modules and disclosable hiera configurations, running unetresgrossebite.com domain services
==================================================================================================

Home-grown Puppet4 modules set, with defaults and custom configurations - excluding active secrets from `hieradata/private.yaml`, and a couple modules including code that's not mine, nor open sourced.
Most of these modules are currently used by my own services (about 30 physicals and 50 VMs), and occasionally hosting customers setup.
With lots of patience and a few changes to `hieradata/` yamls, deploying your own services shouldn't be much complicated.

# Fair Warning

These modules were re-written from scratch for Puppet 3, based on previous Puppet 2 modules. Some of which have not been deployed in a while, and may require patching.

Some headers may be missing, especially on nagios probes or munin plugins.

Our modules depend on some private repository (`repository.unetresgrossebite.com`), fetching a default background for our webserver, statusmaps icons for icinga, phones firmwares, or even packages I don't want to or can't pull from some other repository.
Since my repository also hosts private backups and images, I prefer keeping everything private. Note a fairly-recent copy of these "puppet-distribs" files is available [in a separate public repository](https://gitlab.unetresgrossebite.com/DevOps/puppet-distfiles/tree/master).

Should you need any help understanding what's in there, getting started, ... please get in touch.

# Bootstrap Puppetmaster

Setting up a new Puppetmaster, don't forget to install and enable puppetdb & hiera terminus.
Replace your `/etc/puppetlabs/puppet/hiera.yaml` with the following:

```
---
:hierarchy:
  - "%{domain}/%{hostname}"
  - "%{domain}/%{srvtype}"
  - "%{domain}/defaults"
  - "%{domain}/%{operatingsystem}-%{lsbdistcodename}-%{architecture}"
  - "%{domain}/%{operatingsystem}-%{os.release.major}-%{architecture}"
  - "%{domain}/%{operatingsystem}-%{operatingsystemrelease}-%{architecture}"
  - "%{domain}/%{operatingsystem}-%{lsbdistcodename}"
  - "%{domain}/%{operatingsystem}-%{os.release.major}"
  - "%{domain}/%{operatingsystem}-%{operatingsystemrelease}"
  - "%{domain}/%{operatingsystem}-%{architecture}"
  - "%{domain}/%{operatingsystem}"
  - private
  - "hostgroups/%{hostname}"
  - "serviceclasses/%{srvtype}"
  - "%{operatingsystem}-%{lsbdistcodename}-%{architecture}"
  - "%{operatingsystem}-%{operatingsystemrelease}-%{architecture}"
  - "%{operatingsystem}-%{os.release.major}-%{architecture}"
  - "%{operatingsystem}-%{lsbdistcodename}"
  - "%{operatingsystem}-%{operatingsystemrelease}"
  - "%{operatingsystem}-%{os.release.major}"
  - "%{operatingsystem}-%{architecture}"
  - "%{operatingsystem}"
  - networks
  - common
  - defaults
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppetlabs/code/environments/%{environment}/hieradata'
:logger: console
```

Change your working directory to `/etc/puppetlabs/code/environments/`, clone this repository:

```
test -d production && mv production production.orig
git clone https://github.com/faust64/puppet production
```

To avoid filling your Puppetmaster filesystem with reports, add some daily job running the following:

```
find /var/lib/puppet/reports/ -type f -ctime +7 2>/dev/null | xargs -P 4 -n 20 rm -f
```

# Bootstrap Puppet Agent

To deploy an agent, having trusted its public IP (update required in `hieradata/unetresgrossebite.com/puppet.yaml`), run the following:

```
if test -s /etc/centos-release -o -s /etc/redhat-release; then
    rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum install puppet-agent -y
else
    apt-get update ; apt-get upgrade ; apt-get dist-upgrade ; apt-get autoremove --purge ; apt-get install ca-certificates lsb-release wget
    if grep -E '(devuan|trusty)' /etc/apt/sources.list >/dev/null; then
	dist=trusty
    else
	dist=`lsb_release -sc`
    fi
    if ! grep buster /etc/apt/sources.list >/dev/null; then
	wget https://apt.puppetlabs.com/puppetlabs-release-pc1-$dist.deb
	dpkg -i puppetlabs-release-pc1-$dist.deb
	apt-get update
	apt-get install puppet-agent
    else
	apt-get update
	apt-get install puppet
    fi
fi
export FQDN=`hostname -f`
echo "certname: $FQDN (Y/n)?"
read a
if test "$a" = n; then
    echo abort
    exit 1
fi
if grep buster /etc/apt/sources.list >/dev/null; then
    cat <<EOF >/etc/puppet/puppet.conf
[main]
certname = $FQDN
server = puppet.unetresgrossebite.com
ssldir = /var/lib/puppet/ssl
environment = production
runinterval = 1h
EOF
else
    cat <<EOF >/etc/puppetlabs/puppet/puppet.conf
[main]
certname = $FQDN
server = puppet.unetresgrossebite.com
environment = production
runinterval = 1h
EOF
    . /etc/profile.d/puppet-agent.sh
fi
puppet agent --onetime --test
```
