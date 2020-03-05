class patchdashboard::vars {
    $admin_pw      = "admin"
    $company       = "UneTresGrosseBite"
    $db_name       = "patchdashboard"
    $db_pass       = lookup("patchdashboard_db_passphrase")
    $db_user       = lookup("patchdashboard_db_user")
    $rdomain       = lookup("root_domain")
    $runtime_group = lookup("apache_runtime_group")
    $salt          = lookup("patchdashboard_salt")
    $upstream      = lookup("patchdashboard_upstream")
}
