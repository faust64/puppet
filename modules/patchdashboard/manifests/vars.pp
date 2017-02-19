class patchdashboard::vars {
    $admin_pw      = "admin"
    $company       = "UneTresGrosseBite"
    $db_name       = "patchdashboard"
    $db_pass       = hiera("patchdashboard_db_passphrase")
    $db_user       = hiera("patchdashboard_db_user")
    $download      = hiera("download_cmd")
    $rdomain       = hiera("root_domain")
    $runtime_group = hiera("apache_runtime_group")
    $salt          = hiera("patchdashboard_salt")
    $upstream      = hiera("patchdashboard_upstream")
}
