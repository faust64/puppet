class stanchion::config {
    $admin_key    = $stanchion::vars::admin_key
    $admin_secret = $stanchion::vars::admin_secret
    $dcookie      = $stanchion::vars::dcookie
    $listener     = $stanchion::vars::listen
    $nodename     = $stanchion::vars::nodename
    $riak_master  = $stanchion::vars::riak_master
    $stanchion    = $stanchion::vars::stanchion

    file {
	"Prepare Stanchion for further configuration":
	    ensure  => directory,
	    group   => $stanchion::vars::runtime_group,
	    mode    => "0755",
	    owner   => $stanchion::vars::runtime_user,
	    path    => "/etc/stanchion";
	"Install Stanchion main configuration":
	    content => template("stanchion/config.erb"),
	    group   => $stanchion::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service["stanchion"],
	    owner   => $stanchion::vars::runtime_user,
	    path    => "/etc/stanchion/stanchion.conf",
	    require => File["Prepare Stanchion for further configuration"];
    }
}
