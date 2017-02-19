class riakcs::config {
    $admin_key    = $riakcs::vars::admin_key
    $admin_secret = $riakcs::vars::admin_secret
    $dcookie      = $riakcs::vars::dcookie
    $do_proxy_get = $riakcs::vars::do_proxy_get
    $listener     = $riakcs::vars::listen
    $nodename     = $riakcs::vars::nodename
    $riak_master  = $riakcs::vars::riak_master
    $root_host    = $riakcs::vars::root_host
    $stanchion    = $riakcs::vars::stanchion

    file {
	"Prepare RiakCS for further configuration":
	    ensure  => directory,
	    group   => $riakcs::vars::runtime_group,
	    mode    => "0755",
	    owner   => $riakcs::vars::runtime_user,
	    path    => "/etc/riak-cs";
	"Install RiakCS main configuration":
	    content => template("riakcs/config.erb"),
	    group   => $riakcs::vars::runtime_group,
	    mode    => "0644",
	    notify  => Service["riak-cs"],
	    owner   => $riakcs::vars::runtime_user,
	    path    => "/etc/riak-cs/riak-cs.conf",
	    require => File["Prepare RiakCS for further configuration"];
    }
}
