class asterisk::vars {
    $aastra_datefmt       = hiera("asterisk_aastra_datefmt")
    $aastra_directory     = hiera("asterisk_aastra_directory")
    $aastra_lang          = hiera("asterisk_aastra_default_lang")
    $aastra_tzcode        = hiera("asterisk_aastra_tzcode")
    $aastra_tzfmt         = hiera("asterisk_aastra_tzfmt")
    $aastra_tzname        = hiera("asterisk_aastra_tzname")
    $ami                  = hiera("asterisk_ami")
    $ami_bind_addr        = hiera("asterisk_ami_listen")
    $asterisk_rsyslog     = hiera("asterisk_rsyslog")
    $bacula_user          = hiera("bacula_runtime_user")
    $calltoken_optional   = hiera("asterisk_iax_calltoken_optional")
    $charset              = hiera("locale_charset")
    $common_routes        = hiera("asterisk_common_routes")
    $conf_dir             = hiera("asterisk_conf_dir")
    $config_user          = hiera("nginx_runtime_user")
    $confrooms_all        = hiera("asterisk_conference_rooms")
    $contact              = hiera("generic_contact")
    $dahdi_chans          = hiera("asterisk_dahdi_chans")
    $dahdi_conf_dir       = hiera("dahdi_conf_dir")
    $data_dir             = hiera("asterisk_data_dir")
    $default_sip_pass     = hiera("asterisk_default_sip_passphrase")
    $default_vm_pass      = hiera("asterisk_default_voicemail_passphrase")
    $download             = hiera("download_cmd")
    $extensions_all       = hiera("asterisk_extensions")
    $externalip           = hiera("asterisk_external_ip")
    $fax_from             = hiera("asterisk_fax_from")
    $fax_to               = hiera("asterisk_fax_to")
    $iax_port             = hiera("asterisk_iax_port")
    $iax_trunks           = hiera("asterisk_iax_trunks")
    $localnet             = hiera("asterisk_localnet")
    $lib_dir              = hiera("asterisk_lib_dir")
    $cisco_lang           = hiera("asterisk_cisco_default_lang")
    $local_routes         = hiera("asterisk_local_routes")
    $locale               = hiera("locale")
    $multiple_login       = hiera("asterisk_multiple_login")
    $munin_conf_dir       = hiera("munin_conf_dir")
    $munin_monitored      = hiera("asterisk_munin")
    $munin_probes         = hiera("asterisk_munin_probes")
    $nagios_runtime_group = hiera("nagios_runtime_group")
    $nagios_runtime_user  = hiera("nagios_runtime_user")
    $ntp_upstream         = hiera("ntp_upstream")
    $phones_syslog        = hiera("asterisk_phones_syslog")
    $pickup_contexts      = hiera("asterisk_pickup_contextes")
    $preferred_codecs     = hiera("asterisk_preferred_codecs")
    $queues_all           = hiera("asterisk_queues")
    $register_timeout     = hiera("asterisk_register_timeout")
    $repo                 = hiera("puppet_http_repo")
    $ring_groups_all      = hiera("asterisk_ring_groups")
    $run_dir              = hiera("asterisk_run_dir")
    $runtime_group        = hiera("asterisk_runtime_group")
    $runtime_user         = hiera("asterisk_runtime_user")
    $rsyslog_conf_dir     = hiera("rsyslog_conf_dir")
    $rsyslog_service_name = hiera("rsyslog_service_name")
    $rsyslog_version      = hiera("rsyslog_version")
    $service_name         = hiera("asterisk_service_name")
    $sip_trunks_all       = hiera("asterisk_sip_trunks")
    $spool_dir            = hiera("asterisk_spool_dir")
    $sudo_conf_dir        = hiera("sudo_conf_dir")
    $syslog_host          = hiera("rsyslog_hub")
    $time_conds_all       = hiera("asterisk_time_conditions")
    $var_dir              = hiera("asterisk_var_dir")
#   $vlan_sip             = 8 #FIXME check for actual ID according to active_vlans then vlan_database
    $vlan_sip             = false
    $vlan_users           = 4 #FIXME check for actual ID according to active_vlans then vlan_database
    $version_ary          = split($asterisk_version, '\.')
    $version_maj          = $version_ary[0]
    $webserver_root       = hiera("apache_web_root")

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
