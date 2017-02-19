class wpasupplicant::vars {
    $ap_scan       = hiera("wpasupplicant_ap_scan")
    $auth_algo     = hiera("wpasupplicant_auth_algo")
    $auth_key      = hiera("wpasupplicant_auth_key")
    $auth_type     = hiera("wpasupplicant_auth_type")
    $conf_dir      = hiera("wpasupplicant_conf_dir")
    $pairwise      = hiera("wpasupplicant_pairwise")
    $proto         = hiera("wpasupplicant_proto")
    $run_dir       = hiera("wpasupplicant_run_dir")
    $runtime_group = hiera("wpasupplicant_runtime_group")
#   $service_name  = hiera("wpasupplicant_service_name")
    $ssid          = hiera("wpasupplicant_ssid")
}
