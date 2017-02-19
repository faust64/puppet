class miniflux::vars {
    $download     = hiera("download_cmd")
    $rdomain      = hiera("root_domain")
    $runtime_user = hiera("apache_runtime_user")
    $web_root     = hiera("apache_web_root")
}
