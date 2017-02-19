define mysql::define::grant_replication($dbuser  = $mysql::vars::repl_user,
					$remotes = [ '%' ],
					$tables  = [ '*' ]) {
    each($tables) |$table| {
	each($remotes) |$remote| {
	    $cmd = "GRANT REPLICATION SLAVE ON $name.$table TO '$dbuser'@'$remote'"

	    exec {
		"Grant replication on $name.$table to $dbuser@$remote":
		    command     => "echo \"$cmd\" | mysql -u$msuser -p$mspw",
		    cwd         => "/",
		    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		    refreshonly => true;
	    }
	}
    }
}
