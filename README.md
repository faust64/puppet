puppet modules and disclosable hiera configurations, running unetresgrossebite.com domain services
==================================================================================================

Home-grown Puppet6 modules set, with defaults and custom configurations - excluding active secrets from `data/private.yaml`, and a couple modules including code that's not mine, nor open sourced.
Most of these modules are currently used by my own services (about 30 physicals and 50 VMs), and occasionally hosting customers setup.
With lots of patience and a few changes to `data/` yamls, deploying your own services shouldn't be much complicated.

# Fair Warning

These modules were re-written from scratch for Puppet 3, based on previous Puppet 2 modules, then upgraded from Puppet 4 to 6. Some of which have not been deployed in a while, and may require additional patching.

Some headers may be missing, especially on nagios probes or munin plugins.

Our modules depend on some private repository (`repository.unetresgrossebite.com`), fetching a default background for our webserver, statusmaps icons for icinga, phones firmwares, or even packages I don't want to or can't pull from some other repository.
Since my repository also hosts private backups and images, I prefer keeping everything private. Note a fairly-recent copy of these "puppet-distribs" files is available [in a separate public repository](https://gitlab.unetresgrossebite.com/DevOps/puppet-distfiles/tree/master).

Should you need any help understanding what's in there, getting started, ... please get in touch.

# Bootstrap Puppetmaster

```
<set hostname/ip/...>
# apt-get install wget git
# wget https://apt.puppet.com/puppet<puppetrel>-release-buster.deb
# dpkg -i puppet<puppetrel>-release-buster.deb
# apt-get update
# apt-get install puppetserver postgresql postgresql-contrib
# su - postgres
$ createuser -DRSP puppetdb
$ createdb -E UTF8 -O puppetdb puppetdb
$ psql puppetdb -c 'create extension pg_trgm'
$ exit
# cat <<EOF >>/etc/postgresql/11/main/pg_hba.conf
local  all  all  md5
EOF
# systemctl restart postgresql
# systemctl start puppetserver
# apt-get install puppetdb puppetdb-termini
# cat <<EOF >/etc/puppetlabs/puppetdb/conf.d/database.ini
[database]
subname = //<puppet-fqdn>:5432/puppetdb
username = puppetdb
password = <dbpassword>
EOF
# cat <<EOF >/etc/puppetlabs/puppet/puppetdb.conf
[main]
server_urls = https://<puppet-fqdn>:8081
EOF
# systemctl restart puppetserver
# cat <<EOF >/etc/puppetlabs/puppet/routes.yaml
---
master:
  facts:
    terminus: puppetdb
    cache: yaml
EOF
# chown -R puppet:puppet /etc/puppetlabs/puppet
```

Next, change your working directory to `/etc/puppetlabs/code/environments/`,
and clone this repository:

```
test -d production && mv production production.orig
git clone https://github.com/faust64/puppet production
cd production
puppet module install puppetlabs-stdlib --version 6.3.0
puppet module install puppetlabs-nagios_core --version 1.0.3
```

To avoid filling your Puppetmaster filesystem with reports, add some daily job
running the following:

```
find /var/lib/puppet/reports/ -type f -ctime +7 2>/dev/null | xargs -P 4 -n 20 rm -f
```

# Bootstrap Puppet Agent

To deploy an agent, having trusted its public IP (update `office_netwprks`
firewall configuration in `hieradata/unetresgrossebite.com/puppet.yaml`), run
the following:

```
if test -s /etc/centos-release -o -s /etc/redhat-release; then
    yum -y install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
    yum -y install puppet-agent
else
    apt-get update ; apt-get upgrade ; apt-get dist-upgrade
    apt-get install ca-certificates lsb-release wget puppet
fi
export FQDN=`hostname -f`
echo "certname: $FQDN (Y/n)?"
read a
if test "$a" = n; then
    echo abort
    exit 1
fi
cat <<EOF >/etc/puppet/puppet.conf
[main]
certname = $FQDN
server = <puppet-fqdn>
ssldir = /var/lib/puppet/ssl
environment = production
runinterval = 1h
EOF
puppet agent --onetime --test
```
