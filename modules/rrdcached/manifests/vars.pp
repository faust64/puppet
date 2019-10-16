class rrdcached::vars {
    $basepath     = lookup("rrdcached_basepath")
    $journalowner = lookup("rrdcached_journal_owner")
    $journalpath  = lookup("rrdcached_journal_path")
    $sockfile     = lookup("rrdcached_sockfile")
    $sockgroup    = lookup("rrdcached_sockgroup")
    $sockmode     = lookup("rrdcached_sockmode")
}
