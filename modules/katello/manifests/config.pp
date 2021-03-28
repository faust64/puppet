class katello::config {
    $admpw      = $katello::vars::admin_password
    $admusr     = $katello::vars::admin_user
    $cert_dir   = "/etc/pki/ca-trust/source/anchors"
    $ldap_base  = $openldap::vars::ldap_suffix
    $ldap_slave = $openldap::vars::ldap_slave
    $loc        = $katello::vars::katello_loc
    $org        = $katello::vars::katello_org
    $pptvers    = $katello::vars::puppet_version
    $wrkcnt     = $katello::vars::pulp_workers_count

#    common::define::lined {
#	"Sets Pulp Workers Count":
#	    line    => "PULP_CONCURRENCY=$wrkcnt",
#	    match   => "^PULP_CONCURRENCY",
#	    notify  => Exec["Reload Katello Services"],
#	    path    => "/etc/default/pulp_workers",
#	    require => Exec["Initializes Katello"];
#    }

    file {
	"Install Katello Answers":
	    content => template("katello/katello-answers.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => "root",
	    path    => "/etc/foreman-installer/scenarios.d/katello-answers.yaml",
	    replace => "no", # requires manual removal of packaged copy ...
	    require => Common::Define::Package["katello"];
	"Install Foreman Answers":
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    owner   => "root",
	    path    => "/etc/foreman-installer/scenarios.d/foreman-answers.yaml",
	    replace => "no", # requires manual removal of packaged copy ...
	    require => Common::Define::Package["katello"],
	    source  => "puppet:///modules/katello/foreman-answers.yaml";
	"Install ldap client configuration":
	    content => template("openldap/ldap.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => "root",
	    path    => "/etc/openldap/ldap.conf",
	    require => Class["openldap::client"];
	"Install Foreman Profile":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => "root",
	    path    => "/etc/profile.d/foreman-rake.sh",
	    require => Common::Define::Package["katello"],
	    source  => "puppet:///modules/katello/profile.sh";
	"Link Puppet CA to trust store":
	    ensure  => link,
	    notify  =>
		[
		    Exec["Refresh certificates"],
		    Exec["Reload Katello Services"]
		],
	    path    => "/etc/pki/ca-trust/source/anchors/puppet-ca.pem",
	    source  => "/etc/puppetlabs/puppet/ssl/certs/ca.pem";
    }

    Exec["Refresh certificates"]
	-> Exec["Reload Katello Services"]

    if (! defined(Class["apache::config"])) {
	file {
	    "Install Apache sites-available":
		ensure  => directory,
		group   => lookup("gid_zero"),
		mode    => "0755",
		owner   => "root",
		path    => "/etc/httpd/sites-available";
	    "Install Apache sites-enabled":
		ensure  => link,
		path    => "/etc/httpd/sites-enabled",
		source  => "/etc/httpd/conf.d";
	}
    }

    if ($foreman_proxy_key != "") {
	@@ssh_authorized_key {
	    "foreman-proxy@$fqdn":
		ensure => "present",
		key    => "$foreman_proxy_key",
		tag    => "katello-remote-execution-$fqdn",
		type   => "ssh-rsa",
		user   => "root";
	}
    }

    exec {
	"Update System prior Katello deployment":
	    command     => "yum -y update",
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => Common::Define::Package["epel-release"],
	    timeout     => 600;
	"Initializes Katello":
	    command     => "foreman-installer --scenario katello >foreman-installer.out 2>&1",
	    cwd         => "/root",
	    creates     => "/var/log/foreman-installer/katello.log",
	    path        => "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require     =>
		[
		    File["Install Katello Answers"],
		    File["Install Foreman Answers"]
		],
	    timeout     => 3600;
	"Reload Katello Services":
	    command     => "katello-service restart",
	    environment => [ "HOME=/root" ],
	    path        => "/opt/puppetlabs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true;
    }
}
