class pf::config {
    $ad_ip                  = $pf::vars::ad_ip
    $adm_ip                 = $pf::vars::adm_ip
    $all_networks           = $pf::vars::all_networks
    $all_openvpns           = $pf::vars::all_openvpns
    $allowed_tcp_ports      = $pf::vars::allowed_tcp_ports
    $allowed_udp_ports      = $pf::vars::allowed_udp_ports
    $asterisk_ip            = $pf::vars::asterisk_ip
    $bacula_director_ip     = $pf::vars::bacula_director_ip
    $bacula_fd_port         = $pf::vars::bacula_fd_port
    $bacula_storage_ip      = $pf::vars::bacula_storage_ip
    $bacula_storage_port    = $pf::vars::bacula_storage_port
    $bbb_ip                 = $pf::vars::bbb_ip
    $bgp_database           = $pf::vars::bgp_database
    $bgp_map                = $pf::vars::bgp_map
    $blacklist              = $pf::vars::blacklist
    $can_set_tos            = $pf::vars::can_set_tos
    $dell_ups_ip            = $pf::vars::dell_ups_ip
    $dell_ups_mgr_ip        = $pf::vars::dell_ups_mgr_ip
    $dhcp_ip                = $pf::vars::dhcp_ip
    $dns_ip                 = $pf::vars::dns_ip
    $emby_ip                = $pf::vars::emby_ip
    $git_ip                 = $pf::vars::git_ip
    $gre_tunnels            = $pf::vars::gre_tunnels
    $icecast_ip             = $pf::vars::icecast_ip
    $icecast_upstream       = $pf::vars::icecast_upstream
    $icmp_ip                = $pf::vars::icmp_ip
    $k8s_ip                 = $pf::vars::k8s_ip
    $ldap_ip                = $pf::vars::ldap_ip
    $local_networks         = $pf::vars::local_networks
    $mail_ip                = $pf::vars::mail_ip
    $mail_mx                = $pf::vars::mail_mx
    $main_networks          = $pf::vars::main_networks
    $masterns               = $pf::vars::masterns
    $masterldap             = $pf::vars::masterldap
    $munin_ip               = $pf::vars::munin_ip
    $munin_port             = $pf::vars::munin_port
    $nagios_ip              = $pf::vars::nagios_ip
    $nagios_listenaddr      = $pf::vars::nagios_listenaddr
    $nagios_port            = $pf::vars::nagios_port
    $named_ip               = $pf::vars::named_ip
    $netids                 = $pf::vars::netids
    $office_netid           = $pf::vars::office_netid
    $office_networks        = $pf::vars::office_networks
    $ospf_database          = $pf::vars::ospf_database
    $ovpn_networks          = $pf::vars::ovpn_networks
    $pf_frags_limit         = $pf::vars::pf_frags_limit
    $pf_max_mss             = $pf::vars::pf_max_mss
    $pf_sourcetrack_timeout = $pf::vars::pf_sourcetrack_timeout
    $pf_state_limit         = $pf::vars::pf_state_limit
    $pf_state_policy        = $pf::vars::pf_state_policy
    $pf_table_entries       = $pf::vars::pf_table_entries
    $pf_tables              = $pf::vars::pf_tables
    $plex_ip                = $pf::vars::plex_ip
    $pubmx_ip               = $pf::vars::pubmx_ip
    $pxe_ip                 = $pf::vars::pxe_ip
    $rip_map                = $pf::vars::rip_map
    $sasyncd_peer           = $pf::vars::sasyncd_peer
    $skip_gre               = $pf::vars::skip_gre
    $snmp_ip                = $pf::vars::snmp_ip
    $snmp_listenaddr        = $pf::vars::snmp_listenaddr
    $squid_ip               = $pf::vars::squid_ip
    $svc_ip                 = $pf::vars::svc_ip
    $relayd_http_port       = $pf::vars::relayd_http_port
    $relayd_https_port      = $pf::vars::relayd_https_port
    $reverse_ip             = $pf::vars::reverse_ip
    $sip_providers          = $pf::vars::sip_providers
    $ssh_ip                 = $pf::vars::ssh_ip
    $syslog_ip              = $pf::vars::syslog_ip
    $transmission_ip        = $pf::vars::transmission_ip
    $visio_clients          = $pf::vars::visio_clients
    $visio_ip               = $pf::vars::visio_ip
    $vlist_ip               = $pf::vars::vlist_ip
    $vmwaremgr_ip           = $pf::vars::vmwaremgr_ip
    $vpnserver_ip           = $pf::vars::vpnserver_ip
    $xmpp_ip                = $pf::vars::xmpp_ip

    file {
	"Pf Configuration directory":
	    ensure => directory,
	    group  => lookup("gid_zero"),
	    mode   => "0755",
	    owner  => root,
	    path   => "/etc/pf.d";

	"Pf Interfaces Configuration":
	    content => template("pf/ifs.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/IFS";
	"Pf Alias Configuration":
	    content => template("pf/alias.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Alias";
	"Pf Policy Configuration":
	    content => template("pf/policy.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Policy";
	"Pf Redundancy Configuration":
	    content => template("pf/redundancy.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Redundancy";
	"Pf NAT Configuration":
	    content => template("pf/nat.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/NAT";
	"Pf SIP Configuration":
	    content => template("pf/sip.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/SIP";
	"Pf Local Services Configuration":
	    content => template("pf/services.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Services";
	"PF global ACL Configuration":
	    content => template("pf/intranet.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/Intranet",
	    require => File["Pf Configuration directory"];
	"Pf Main Configuration":
	    content => template("pf/pf.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.conf";
    }

    File["Pf Configuration directory"]
	-> File["Pf Alias Configuration"]
	-> File["Pf Interfaces Configuration"]
	-> File["PF global ACL Configuration"]
	-> File["Pf Policy Configuration"]
	-> File["Pf Redundancy Configuration"]
	-> File["Pf SIP Configuration"]
	-> File["Pf Local Services Configuration"]
	-> File["Pf NAT Configuration"]
	-> File["Pf Main Configuration"]
}
