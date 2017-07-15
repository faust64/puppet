class wpasupplicant::vars {
    $ap_scan       = lookup("wpasupplicant_ap_scan")
    $auth_algo     = lookup("wpasupplicant_auth_algo")
    $auth_key      = lookup("wpasupplicant_auth_key")
    $auth_type     = lookup("wpasupplicant_auth_type")
    $conf_dir      = lookup("wpasupplicant_conf_dir")
    $pairwise      = lookup("wpasupplicant_pairwise")
    $proto         = lookup("wpasupplicant_proto")
    $run_dir       = lookup("wpasupplicant_run_dir")
    $runtime_group = lookup("wpasupplicant_runtime_group")
#   $service_name  = lookup("wpasupplicant_service_name")
    $ssid          = lookup("wpasupplicant_ssid")
}
