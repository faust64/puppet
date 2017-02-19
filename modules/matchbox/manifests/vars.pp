class matchbox::vars {
    $app_url           = hiera("matchbox_app_url")
    $feed_url          = hiera("matchbox_feed_url")
    $home_dir          = hiera("generic_home_dir")
    $preferred_browser = hiera("preferred_browser")
    $runtime_user      = hiera("matchbox_runtime_user")
}
