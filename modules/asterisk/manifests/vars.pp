class asterisk::vars {
    $aastra_datefmt       = lookup("asterisk_aastra_datefmt")
    $aastra_directory     = lookup("asterisk_aastra_directory")
    $aastra_lang          = lookup("asterisk_aastra_default_lang")
    $aastra_tzcode        = lookup("asterisk_aastra_tzcode")
    $aastra_tzfmt         = lookup("asterisk_aastra_tzfmt")
    $aastra_tzname        = lookup("asterisk_aastra_tzname")
    $ami                  = lookup("asterisk_ami")
    $ami_bind_addr        = lookup("asterisk_ami_listen")
    $asterisk_rsyslog     = lookup("asterisk_rsyslog")
    $bacula_user          = lookup("bacula_runtime_user")
    $calltoken_optional   = lookup("asterisk_iax_calltoken_optional")
    $charset              = lookup("locale_charset")
    $common_routes        = lookup("asterisk_common_routes")
    $conf_dir             = lookup("asterisk_conf_dir")
    $config_user          = lookup("nginx_runtime_user")
    $confrooms_all        = lookup("asterisk_conference_rooms")
    $contact              = lookup("generic_contact")
    $dahdi_chans          = lookup("asterisk_dahdi_chans")
    $dahdi_conf_dir       = lookup("dahdi_conf_dir")
    $data_dir             = lookup("asterisk_data_dir")
    $default_sip_pass     = lookup("asterisk_default_sip_passphrase")
    $default_vm_pass      = lookup("asterisk_default_voicemail_passphrase")
    $download             = lookup("download_cmd")
    $extensions_all       = lookup("asterisk_extensions")
    $externalip           = lookup("asterisk_external_ip")
    $fax_from             = lookup("asterisk_fax_from")
    $fax_to               = lookup("asterisk_fax_to")
    $iax_port             = lookup("asterisk_iax_port")
    $iax_trunks           = lookup("asterisk_iax_trunks")
    $localnet             = lookup("asterisk_localnet")
    $lib_dir              = lookup("asterisk_lib_dir")
    $cisco_lang           = lookup("asterisk_cisco_default_lang")
    $local_routes         = lookup("asterisk_local_routes")
    $locale               = lookup("locale")
    $multiple_login       = lookup("asterisk_multiple_login")
    $munin_conf_dir       = lookup("munin_conf_dir")
    $munin_monitored      = lookup("asterisk_munin")
    $munin_probes         = lookup("asterisk_munin_probes")
    $munin_service_name   = lookup("munin_node_service_name")
    $nagios_runtime_group = lookup("nagios_runtime_group")
    $nagios_runtime_user  = lookup("nagios_runtime_user")
    $ntp_upstream         = lookup("ntp_upstream")
    $phones_syslog        = lookup("asterisk_phones_syslog")
    $pickup_contexts      = lookup("asterisk_pickup_contextes")
    $preferred_codecs     = lookup("asterisk_preferred_codecs")
    $queues_all           = lookup("asterisk_queues")
    $register_timeout     = lookup("asterisk_register_timeout")
    $repo                 = lookup("puppet_http_repo")
    $ring_groups_all      = lookup("asterisk_ring_groups")
    $run_dir              = lookup("asterisk_run_dir")
    $runtime_group        = lookup("asterisk_runtime_group")
    $runtime_user         = lookup("asterisk_runtime_user")
    $rsyslog_conf_dir     = lookup("rsyslog_conf_dir")
    $rsyslog_service_name = lookup("rsyslog_service_name")
    $rsyslog_version      = lookup("rsyslog_version")
    $service_name         = lookup("asterisk_service_name")
    $sip_trunks_all       = lookup("asterisk_sip_trunks")
    $spool_dir            = lookup("asterisk_spool_dir")
    $sudo_conf_dir        = lookup("sudo_conf_dir")
    $syslog_host          = lookup("rsyslog_hub")
    $time_conds_all       = lookup("asterisk_time_conditions")
    $var_dir              = lookup("asterisk_var_dir")
#   $vlan_sip             = 8 #FIXME check for actual ID according to active_vlans then vlan_database
    $vlan_sip             = false
    $vlan_users           = 4 #FIXME check for actual ID according to active_vlans then vlan_database
    $version_ary          = split($asterisk_version, '\.')
    $version_maj          = $version_ary[0]
    $webserver_root       = lookup("apache_web_root")

    $extensions           = $extensions_all[$domain]
    if ($confrooms_all != false) {
	$conference_rooms = $confrooms_all[$domain]
    } else {
	$conference_rooms = false
    }
    if ($queues_all != false) {
	$queues           = $queues_all[$domain]
    } else {
	$queues           = false
    }
    if ($ring_groups_all != false) {
	$ring_groups      = $ring_groups_all[$domain]
    } else {
	$ring_groups      = false
    }
    if ($sip_trunks_all != false) {
	$sip_trunks       = $sip_trunks_all[$domain]
    } else {
	$sip_trunks       = false
    }
    if ($time_conds_all != false) {
	$time_conditions  = $time_conds_all[$domain]
    } else {
	$time_conditions  = false
    }

    $timezone = $locale ? {
	"uk"    => "GMT+02:00",
	default => "GMT+01:00"
    }
}
