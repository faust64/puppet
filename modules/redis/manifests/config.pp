class redis::config {
    $conf_dir      = $redis::vars::conf_dir
    $databases     = $redis::vars::databases
    $limits        = $redis::vars::limits
    $listen_addr   = $redis::vars::listen_address
    $listen_port   = $redis::vars::listen_port
    $repl_backlog  = $redis::vars::repl_backlog
    $repl_pass     = $redis::vars::repl_pass
    $save          = $redis::vars::save
    $serve_stale   = $redis::vars::serve_stale
    $slave_prio    = $redis::vars::slave_priority
    $slave_ro      = $redis::vars::slave_read_only
    $slavelag      = $redis::vars::slavelag
    $slavemin      = $redis::vars::slavemin
    $slaveof       = $redis::vars::slaveof
    $timeout       = $redis::vars::timeout
    $tcp_keepalive = $redis::vars::tcp_keepalive

    file {
	"Prepare redis for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install redis main configuration":
	    content => template("redis/config.erb"),
	    group   => $redis::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$redis::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/redis.conf",
	    require => File["Prepare redis for further configuration"];
    }

    mysysctl::define::setfile {
	"redis":
	    source => "redis/sysctl.conf";
    }

    Mysysctl::Define::Setfile["redis"]
	-> Service[$redis::vars::service_name]
}
