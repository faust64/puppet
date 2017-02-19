class rrdcached::vars {
    $munin_group = hiera("munin_group")
    $munin_user  = hiera("munin_user")
    $opts        = hiera("rrdcached_opts")
}
