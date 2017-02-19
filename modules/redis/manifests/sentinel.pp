class redis::sentinel {
    $conf_dir         = $redis::vars::conf_dir
    $down_timeout     = $redis::vars::down_timeout
    $failover_timeout = $redis::vars::failover_timeout
    $listen_port      = $redis::vars::listen_port
    $quorum           = $redis::vars::sentinel_quorum
    $repl_pass        = $redis::vars::repl_pass
    $sentinel_port    = $redis::vars::sentinel_port
    $sentinel_name    = $redis::vars::sentinel_name
    $slaveof          = $redis::vars::slaveof

    exec {
	"Drop unlikely-to-exist default Redis Sentinel configuration":
	    command => "rm -f sentinel.conf",
	    cwd     => $conf_dir,
	    onlyif  => "test -f sentinel.conf",
	    path    => "/usr/bin:/bin",
	    require => File["Prepare redis for further configuration"],
	    unless  => "grep ^loglevel sentinel.conf";
    }

    file {
	"Install Redis Sentinel configuration":
	    content => template("redis/sentinel.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0640",
	    notify  => Service["redis-sentinel"],
	    owner   => $redis::vars::runtime_user,
	    path    => "$conf_dir/sentinel.conf",
	    replace => false,
	    require => Exec["Drop unlikely-to-exist default Redis Sentinel configuration"];
    }
}
