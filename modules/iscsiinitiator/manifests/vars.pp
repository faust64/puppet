class iscsiinitiator::vars {
    $abrt_timeout        = lookup("iscsi_abrt_timeout")
    $cmd_max             = lookup("iscsi_cmd_max")
    $conf_dir            = lookup("iscsi_conf_dir")
    $fast_abort          = lookup("iscsi_fast_abort")
    $first_burst_len     = lookup("iscsi_first_burst_len")
    $immediate_data      = lookup("iscsi_immediate_data")
    $initial_r2t         = lookup("iscsi_initial_r2t")
    $iscsid_bin          = lookup("iscsid_bin")
    $login_max_retry     = lookup("iscsi_login_max_retry")
    $login_timeout       = lookup("iscsi_login_timeout")
    $logout_timeout      = lookup("iscsi_logout_timeout")
    $max_burst_len       = lookup("iscsi_max_burst_len")
    $noop_out_itv        = lookup("iscsi_noop_out_itv")
    $noop_out_timeout    = lookup("iscsi_noop_out_timeout")
    $queue_depth         = lookup("iscsi_queue_depth")
    $replacement_timeout = lookup("iscsi_replacement_timeout")
    $reset_timeout       = lookup("iscsi_reset_timeout")
    $xmit_priority       = lookup("iscsi_xmit_priority")

# convert fqdn to initiatorname, requires 'reverse' from puppet' stdlib
    $ordered             = split($fqdn, '\.')
    $iname               = reverse($ordered).join('.')
}
