class tunner::vars {
    $download = hiera("download_cmd")
    $driver   = hiera("tunner_driver")
    $provider = hiera("tunner_driver_provider")
}
