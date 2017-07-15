class sonarr::vars {
    $rdomain       = lookup("root_domain")
    $runtime_group = lookup("sonarr_runtime_group")
    $runtime_user  = lookup("sonarr_runtime_user")
}
