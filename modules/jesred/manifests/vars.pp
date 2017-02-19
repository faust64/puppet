class jesred::vars {
    $apt_cacher  = hiera("apt_cacher")
    $log_dir     = hiera("squid_log_dir")
    $regexplist  = hiera("jesred_regexpr")
    $rewrite_for = hiera("jesred_rewrite_for")
}
