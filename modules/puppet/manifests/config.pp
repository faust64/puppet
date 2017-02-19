class puppet::config {
    $conf_dir       = $puppet::vars::conf_dir
    $puppet_master  = $puppet::vars::puppet_master
    $puppet_run_dir = $puppet::vars::puppet_run_dir
    $puppet_run_itv = $puppet::vars::puppet_run_itv
    $puppet_tag     = $puppet::vars::puppet_tag
    $puppet_var_dir = $puppet::vars::puppet_var_dir

    file {
	"Prepare Puppet for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Puppet main configuration":
	    content => template("puppet/puppet.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Common::Define::Service[$puppet::vars::puppet_srvname],
	    owner   => root,
	    path    => "$conf_dir/puppet.conf",
	    require => File["Puppet auth configuration"];
	"Puppet auth configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Common::Define::Service[$puppet::vars::puppet_srvname],
	    owner   => root,
	    path    => "$conf_dir/auth.conf",
	    require => File["Prepare Puppet for further configuration"],
	    source  => "puppet:///modules/puppet/auth.conf";
	"Puppet profile configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/profile.d/puppet-agent.sh",
	    source  => "puppet:///modules/puppet/profile.sh";
    }
}
