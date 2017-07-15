class rrdcached::vars {
    $munin_group = lookup("munin_group")
    $munin_user  = lookup("munin_user")
    $opts        = lookup("rrdcached_opts")
}
