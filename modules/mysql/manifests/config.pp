class mysql::config {
    $bind_addr       = $mysql::vars::bind_addr
    $binlog_do_db    = $mysql::vars::binlog_do_db
    $charset         = $mysql::vars::charset
    $conf_dir        = $mysql::vars::conf_dir
    $expire_log_days = $mysql::vars::expire_log_days
    $include_dir     = $mysql::vars::include_dir
    $key_buffer      = $mysql::vars::key_buffer
    $lib_dir         = $mysql::vars::lib_dir
    $log_slowqueries = $mysql::vars::log_slowqueries
    $mxallowedpkt    = $mysql::vars::max_allowed_packet
    $mxbinlogsize    = $mysql::vars::max_binlog_size
    $mxconnx         = $mysql::vars::max_connections
    $pid_file        = $mysql::vars::pid_file
    $provider        = $mysql::vars::provider
    $qclimit         = $mysql::vars::query_cache_limit
    $qcsize          = $mysql::vars::query_cache_size
    $readbufsize     = $mysql::vars::read_buffer_size
    $repl_do_table   = $mysql::vars::replicate_do_table
    $repl_from       = $mysql::vars::replicate_from
    $repl_pass       = $mysql::vars::repl_pass
    $repl_user       = $mysql::vars::repl_user
    $runtime_user    = $mysql::vars::runtime_user
    $server_id       = $mysql::vars::server_id
    $sock_dir        = $mysql::vars::sock_dir
    $sock_file       = $mysql::vars::sock_file
    $sortbufsize     = $mysql::vars::sort_buffer_size
    $table_cache     = $mysql::vars::table_cache
    $tcsize          = $mysql::vars::thread_cache_size
    $tstack          = $mysql::vars::thread_stack
    $threadconcr     = $mysql::vars::thread_concurrency

    if ($binlog_do_db != false) {
	mysql::define::create_user {
	    $repl_user:
		dbpass => $repl_pass;
	}

	each($binlog_db_db) |$db| {
	    mysql::define::grant_replication {
		$db:
	    }

	    Mysql::Define::Create_user[$repl_user]
		~> Mysql::Define::Grant_replication[$db]
#FIXME: mysqldump tables / import on slave *before* changing master
# eventually, using --master-data should prevent from CHANGE MASTER on the slave
# could be done from set_master, say using mysqldump -H repl_from ...?
# this code is theoretical/not used yet, I'll think about it a little more, ...
	}
    } elsif ($server_id != false and $repl_from != false) {
	mysql::define::set_master {
	    $repl_from:
		dbpass => $repl_pass,
		dbuser => $repl_user;
	}
    }

    file {
	"Prepare MySQL included configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $include_dir;
	"Install MySQL main configuration":
	    content => template("mysql/my.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$mysql::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/my.cnf",
	    require => File["Prepare MySQL included configuration directory"];
    }

    if ($conf_dir != "/etc" and $conf_dir != "/usr/local/etc") {
	file {
	    "Prepare MySQL for further configuration":
		ensure => directory,
		group  => lookup("gid_zero"),
		mode   => "0755",
		owner  => root,
		path   => $conf_dir;
	}

	File["Prepare MySQL for further configuration"]
	    -> File["Prepare MySQL included configuration directory"]
    }
}
