class nagios::vars {
    $contact_escalate    = hiera("nagios_contact_escalate")
    $dmidecode_bin       = hiera("dmidecode_bin")
    $dns_proof           = hiera("nagios_dns_proof")
    $icmp_proof          = hiera("nagios_icmp_proof")
    $iconimage           = hiera("nagios_iconimage")
    $iconimagealt        = hiera("nagios_iconimagealt")
    $ipmitool_bin        = hiera("ipmitool_bin")
    $nagios_class        = hiera("nagios_host_class")
    $nagios_conf_dir     = hiera("nagios_conf_dir")
    $nagios_hostgroup    = hiera("nagios_hostgroup")
    $nagios_ip           = hiera("nagios_ip")
    $nagios_load_crit    = hiera("nagios_load_crit_threshold")
    $nagios_load_warn    = hiera("nagios_load_warn_threshold")
    $nagios_listenaddr   = hiera("nagios_listenaddr")
    $nagios_nataddr      = hiera("nagios_nat_listenaddr")
    $nagios_parent       = hiera("physical_parent")
    $nagios_plugins_dir  = hiera("nagios_plugins_dir")
    $nagios_port         = hiera("nagios_nrpe_port")
    $nagios_run_dir      = hiera("nagios_run_dir")
    $nagios_runtime_user = hiera("nagios_runtime_user")
    $no_parent           = hiera("nagios_no_parent")
    $nrpe_service_name   = hiera("nagios_nrpe_service_name")
    $nrpe_timeout        = hiera("nagios_nrpe_timeout")
    $pid_file            = hiera("nagios_nrpe_pid_file")
    $procs_crit          = hiera("nagios_procs_crit")
    $procs_warn          = hiera("nagios_procs_warn")
    $reboot_month_day    = hiera("reboot_month_day")
    $reboot_week_day     = hiera("reboot_week_day")
    $runprocs_crit       = hiera("nagios_runprocs_crit")
    $runprocs_warn       = hiera("nagios_runprocs_warn")
    $runtime_group       = hiera("nagios_runtime_group")
    $runtime_user        = hiera("nagios_runtime_user")
    $statusmapimage      = hiera("nagios_statusmapimage")
    $users_crit          = hiera("nagios_users_crit")
    $users_warn          = hiera("nagios_users_warn")
    $ssh_port            = hiera("ssh_port")
    $sudo_conf_dir       = hiera("sudo_conf_dir")
    $tmpdev              = hiera("tmp_target_device")
    $watch_hpraid        = hiera("nagios_hp_raid")
    $watch_mdraid        = hiera("nagios_md_raid")
    $watchlist           = hiera("nagios_partitions_watchlist")

    if ($no_parent) {
	$parents = false
    } elsif ($nagios_parent) {
	$parents = $nagios_parent
    } elsif ($parent != "") {
	$parents = $parent
    } else {
	$parents = false
    }

    if ($nagios_listenaddr) {
	$listen = $nagios_listenaddr
    } else {
	$listen = $ipaddress
    }
    if ($nagios_nataddr) {
	$remoteaddr = $nagios_nataddr
    } else {
	$remoteaddr = $listen
    }
    if ($nagios_load_warn) {
	$load_warn_threshold = $nagios_load_warn
    } else {
	$minone = $processorcount.to_i - 1
	$load_warn_threshold = "$processorcount.1,$minone.8,$minone.1"
    }
    if ($nagios_load_crit) {
	$load_crit_threshold = $nagios_load_crit
    } else {
	$load_crit_threshold = "$processorcount.0,$processorcount.0,$processorcount.0"
    }
    $conn_timeout = $nrpe_timeout * 5
    if ($reboot_week_day != false) {
	$uptimeargs = [ "-c 14", "-w 7" ]
    } elsif ($reboot_month_day != false) {
	$uptimeargs = [ "-c 50", "-w 35" ]
    } else { $uptimeargs = false }
}
