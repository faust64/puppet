class media::vars {
    $music     = hiera("media_subsonic")
    $rdomain   = hiera("root_domain")
    $sickbeard = hiera("media_sickbeard")
    $web_root  = hiera("media_web_root")
}
