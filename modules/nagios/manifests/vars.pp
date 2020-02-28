class nagios::vars {
    $contact_escalate    = lookup("nagios_contact_escalate")
    $dmidecode_bin       = lookup("dmidecode_bin")
    $dns_proof           = lookup("nagios_dns_proof")
    $icmp_proof          = lookup("nagios_icmp_proof")
    $iconimage           = lookup("nagios_iconimage")
    $iconimagealt        = lookup("nagios_iconimagealt")
    $ipmitool_bin        = lookup("ipmitool_bin")
    $jumbo_check         = lookup("nagios_check_jumbo")
    $nagios_class        = lookup("nagios_host_class")
    $nagios_conf_dir     = lookup("nagios_conf_dir")
    $nagios_hostgroup    = lookup("nagios_hostgroup")
    $nagios_ip           = lookup("nagios_ip")
    $nagios_load_crit    = lookup("nagios_load_crit_threshold")
    $nagios_load_warn    = lookup("nagios_load_warn_threshold")
    $nagios_listenaddr   = lookup("nagios_listenaddr")
    $nagios_nataddr      = lookup("nagios_nat_listenaddr")
    $nagios_parent       = lookup("physical_parent")
    $nagios_plugins_dir  = lookup("nagios_plugins_dir")
    $nagios_port         = lookup("nagios_nrpe_port")
    $nagios_run_dir      = lookup("nagios_run_dir")
    $no_parent           = lookup("nagios_no_parent")
    $nrpe_service_name   = lookup("nagios_nrpe_service_name")
    $nrpe_timeout        = lookup("nagios_nrpe_timeout")
    $pid_file            = lookup("nagios_nrpe_pid_file")
    $procs_crit          = lookup("nagios_procs_crit")
    $procs_warn          = lookup("nagios_procs_warn")
    $reboot_month_day    = lookup("reboot_month_day")
    $reboot_week_day     = lookup("reboot_week_day")
    $runprocs_crit       = lookup("nagios_runprocs_crit")
    $runprocs_warn       = lookup("nagios_runprocs_warn")
    $runtime_group       = lookup("nagios_runtime_group")
    $runtime_user        = lookup("nagios_runtime_user")
    $statusmapimage      = lookup("nagios_statusmapimage")
    $users_crit          = lookup("nagios_users_crit")
    $users_warn          = lookup("nagios_users_warn")
    $ssh_port            = lookup("ssh_port")
    $sudo_conf_dir       = lookup("sudo_conf_dir")
    $tmpdev              = lookup("tmp_target_device")
    $watch_hpraid        = lookup("nagios_hp_raid")
    $watch_mdraid        = lookup("nagios_md_raid")
    $watchlist           = lookup("nagios_partitions_watchlist")

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
