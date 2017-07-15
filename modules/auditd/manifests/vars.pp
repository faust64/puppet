class auditd::vars {
    $buffer_size      = lookup("auditd_buffer_size")
    $conf_dir         = lookup("auditd_conf_dir")
    $contact          = lookup("auditd_contact")
    $keep             = lookup("auditd_keep_logs")
    $max_logfile_size = lookup("auditd_max_logfile_size")
    $plugins_conf_dir = lookup("auditd_plugins_conf_dir")
}
