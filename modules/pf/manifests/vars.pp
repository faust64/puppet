class pf::vars {
    $ad_ip                  = lookup("ad_ip")
    $adm_ip                 = lookup("adm_ip")
    $all_networks           = lookup("vlan_database", {merge => hash})
    $all_openvpns           = lookup("openvpn_database", {merge => hash})
    $allowed_tcp_ports      = lookup("allowed_tcp_ports")
    $allowed_udp_ports      = lookup("allowed_udp_ports")
    $array_dom              = split($domain, '\.')
    $asterisk_ip            = lookup("asterisk_ip")
    $asterisk_service_keys  = lookup("asterisk_service_keys")
    $bacula_director_ip     = lookup("bacula_director_ip")
    $bacula_fd_port         = lookup("bacula_file_daemon_port")
    $bacula_storage_ip      = lookup("bacula_storage_ip")
    $bacula_storage_port    = lookup("bacula_storage_port")
    $bbb_ip                 = lookup("bigbluebutton_ip")
    $bgp_database           = lookup("bgp_database")
    $bgp_map                = lookup("bgp_map")
    $blacklist              = lookup("blacklist")
    $can_set_tos            = lookup("can_set_tos")
    $dell_ups_ip            = lookup("dell_ups_ip")
    $dell_ups_mgr_ip        = lookup("dell_ups_mgr_ip")
    $dhcp_ip                = lookup("dhcp_ip")
    $do_relay_dhcp          = lookup("ifstated_dhcrelay")
    $dns_ip                 = lookup("dns_ip")
    $emby_ip                = lookup("emby_ip")
    $ftpproxy_port          = lookup("ftpproxy_local_port")
    $git_ip                 = lookup("pubgit_ip")
    $gre_tunnels            = lookup("gre_tunnels")
    $icecast_ip             = lookup("icecast_ip")
    $icecast_upstream       = lookup("icecast_upstream_ip")
    $icmp_ip                = lookup("icmp_ip")
    $ipsec_tunnels          = lookup("ipsec_tunnels")
    $k8s_ip                 = lookup("k8s_ip")
    $ldap_ip                = lookup("ldap_ip")
    $local_networks         = lookup("active_vlans")
    $mail_ip                = lookup("mail_ip")
    $mail_mx                = lookup("mail_mx")
    $main_networks          = lookup("net_ifs")
    $masterns               = lookup("dns_masters")
    $masterldap             = lookup("ldap_masters")
    $munin_conf_dir         = lookup("munin_conf_dir")
    $munin_ip               = lookup("munin_ip")
    $munin_monitored        = lookup("pf_munin")
    $munin_port             = lookup("munin_port")
    $munin_probes           = lookup("pf_munin_probes")
    $muninnode_service_name = lookup("munin_node_service_name")
    $nagios_ip              = lookup("nagios_ip")
    $nagios_listenaddr      = lookup("nagios_listenaddr")
    $nagios_port            = lookup("nagios_nrpe_port")
    $nagios_runtime_user    = lookup("nagios_runtime_user")
    $named_ip               = lookup("named_master")
    $netids                 = lookup("office_netids")
    $office_netid           = $netids[$domain]
    $office_networks        = lookup("office_networks")
    $openvpn_conf_dir       = lookup("openvpn_conf_dir")
    $openvpn_pushd_networks = lookup("openvpn_push_networks")
    $ospf_database          = lookup("ospf_database")
    $ospf_map               = lookup("ospf_map")
    $ovpn_networks          = lookup("active_openvpns")
    $pf_custom_rules        = lookup("pf_custom_rules", {merge => hash})
    $pf_frags_limit         = lookup("pf_frags_limit")
    $pf_max_mss             = lookup("pf_max_mss")
    $pf_sourcetrack_timeout = lookup("pf_sourcetrack_timeout")
    $pf_state_limit         = lookup("pf_state_limit")
    $pf_state_policy        = lookup("pf_state_policy")
    $pf_table_entries       = lookup("pf_table_entries")
    $pf_tables              = lookup("pf_tables")
    $plex_ip                = lookup("plex_ip")
    $pxe_ip                 = lookup("pxe_ip")
    $qos_bw_bulk            = lookup("qos_bw_bulk")
    $qos_bw_data            = lookup("qos_bw_data")
    $qos_bw_interactive     = lookup("qos_bw_interactive")
    $qos_bw_voip            = lookup("qos_bw_voip")
    $qos_root_if            = lookup("qos_root_if")
    $qos_root_bandwidth     = lookup("qos_root_bandwidth")
    $relayd_http_port       = lookup("relayd_http_port")
    $relayd_https_port      = lookup("relayd_https_port")
    $reverse_ip             = lookup("reverse_ip")
    $rip_map                = lookup("rip_map")
    $sasyncd_peer           = lookup("sasyncd_peer")
    $skip_gre               = lookup("pf_skip_gre")
    $short_domain           = $array_dom[0]
    $sip_providers          = lookup("sip_providers")
    $sip_trunks             = lookup("asterisk_sip_trunks")
    $svc_ip                 = lookup("pf_svc_ip")
    $pubmx_ip               = lookup("pubmx_ip")
    $pubreverse_ip          = lookup("pubreverse_ip")
    $snmp_ip                = lookup("snmp_ip")
    $snmp_listenaddr        = lookup("snmp_listenaddr")
    $squid_ip               = lookup("squid_ip")
    $ssh_ip                 = lookup("ssh_ip")
    $ssh_port               = lookup("ssh_port")
    $sudo_conf_dir          = lookup("sudo_conf_dir")
    $syslog_ip              = lookup("rsyslog_hub")
    $tftpproxy_port         = lookup("tftpproxy_local_port")
    $transmission_alt_ip    = lookup("transmission_alt_ip")
    $transmission_ip        = lookup("transmission_ip")
    $visio_clients          = lookup("visio_clients")
    $visio_ip               = lookup("visio_ip")
    $vlist_ip               = lookup("vlist_ip")
    $vmwaremgr_ip           = lookup("vmwaremgr_ip")
    $vpnserver_if           = lookup("vpnserver_if")
    $vpnserver_ip           = lookup("vpnserver_ip")
    $xmpp_ip                = lookup("xmpp_ip")

    if (defined(Class["tftpd"])) {
	$pxe_is_here = true
    } else {
	$pxe_is_here = false
    }

    $linkvaldb =
	{
	    'sdslsdsl' => 1,
	    'sdsladsl' => 2,
	    'sdslsip' => 3,
	    'adslsdsl' => 4,
	    'adsladsl' => 5,
	    'adslsip' => 6,
	    'sipsdsl' => 7,
	    'sipadsl' => 8,
	    'sipsip' => 9
	}
}
