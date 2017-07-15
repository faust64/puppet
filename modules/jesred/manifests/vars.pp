class jesred::vars {
    $apt_cacher  = lookup("apt_cacher")
    $log_dir     = lookup("squid_log_dir")
    $regexplist  = lookup("jesred_regexpr")
    $rewrite_for = lookup("jesred_rewrite_for")
}
