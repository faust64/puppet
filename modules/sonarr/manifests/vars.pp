class sonarr::vars {
    $rdomain       = hiera("root_domain")
    $runtime_group = hiera("sonarr_runtime_group")
    $runtime_user  = hiera("sonarr_runtime_user")
}
