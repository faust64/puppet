class riak::config {
    $backend            = $riak::vars::backend
    $dcookie            = $riak::vars::dcookie
    $do_aae             = $riak::vars::do_aae
    $do_control         = $riak::vars::do_control
    $do_fullsync        = $riak::vars::do_fullsync
    $do_riakcs          = $riak::vars::do_riakcs
    $enterprise         = $riak::vars::enterprise
    $fullsync_downgrade = $riak::vars::fullsync_downgrade
    $http               = $riak::vars::port_http
    $leveldb_compress   = $riak::vars::leveldb_compress
    $listener           = $riak::vars::listen
    $mmp                = $riak::vars::max_memory_percent
    $nodename           = $riak::vars::nodename
    $protobuf           = $riak::vars::port_protobuf
    $do_ssl             = $riak::vars::riak_ssl
    $riakcs_version     = $riak::vars::riakcs_version

    file {
	"Prepare riak for further configuration":
	    ensure  => directory,
	    group   => $riak::vars::runtime_group,
	    mode    => "0755",
	    owner   => $riak::vars::runtime_user,
	    path    => "/etc/riak";
	"Install riak main configuration":
	    content => template("riak/config.erb"),
	    group   => $riak::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service["riak"],
	    owner   => $riak::vars::runtime_user,
	    path    => "/etc/riak/riak.conf",
	    require => File["Prepare riak for further configuration"];
	"Install Riak advanced configuration":
	    content => template("riak/advanced.erb"),
	    group   => $riak::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service["riak"],
	    owner   => $riak::vars::runtime_user,
	    path    => "/etc/riak/advanced.config",
	    require => File["Prepare riak for further configuration"];
	"Install Riak limits configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    notify  => Service["riak"],
	    path    => "/etc/security/limits.d/riak.conf",
	    require => File["Prepare riak for further configuration"],
	    source  => "puppet:///modules/riak/limits.conf";
    }

    mysysctl::define::setfile {
	"riak":
	    source => "riak/sysctl.conf";
    }

    Mysysctl::Define::Setfile["riak"]
	-> Service["riak"]
}
