class iscsiinitiator::vars {
    $abrt_timeout        = hiera("iscsi_abrt_timeout")
    $cmd_max             = hiera("iscsi_cmd_max")
    $conf_dir            = hiera("iscsi_conf_dir")
    $fast_abort          = hiera("iscsi_fast_abort")
    $first_burst_len     = hiera("iscsi_first_burst_len")
    $immediate_data      = hiera("iscsi_immediate_data")
    $initial_r2t         = hiera("iscsi_initial_r2t")
    $iscsid_bin          = hiera("iscsid_bin")
    $login_max_retry     = hiera("iscsi_login_max_retry")
    $login_timeout       = hiera("iscsi_login_timeout")
    $logout_timeout      = hiera("iscsi_logout_timeout")
    $max_burst_len       = hiera("iscsi_max_burst_len")
    $noop_out_itv        = hiera("iscsi_noop_out_itv")
    $noop_out_timeout    = hiera("iscsi_noop_out_timeout")
    $queue_depth         = hiera("iscsi_queue_depth")
    $replacement_timeout = hiera("iscsi_replacement_timeout")
    $reset_timeout       = hiera("iscsi_reset_timeout")
    $xmit_priority       = hiera("iscsi_xmit_priority")

# convert fqdn to initiatorname, requires 'reverse' from puppet' stdlib
    $ordered             = split($fqdn, '\.')
    $iname               = reverse($ordered).join('.')
}
