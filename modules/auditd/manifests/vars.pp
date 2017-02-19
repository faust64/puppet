class auditd::vars {
    $buffer_size      = hiera("auditd_buffer_size")
    $conf_dir         = hiera("auditd_conf_dir")
    $contact          = hiera("auditd_contact")
    $keep             = hiera("auditd_keep_logs")
    $max_logfile_size = hiera("auditd_max_logfile_size")
    $plugins_conf_dir = hiera("auditd_plugins_conf_dir")
}
