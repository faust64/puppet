class ceph::vars {
    $apache_runtime_user      = lookup("apache_runtime_user")
    $apache_service           = lookup("apache_service_name")
    $dash_client              = lookup("ceph_dashboard_client_name")
    $dash_keyring             = lookup("ceph_dashboard_client_keyring")
    $do_dashboard             = lookup("ceph_do_dashboard")
    $cluster_name             = lookup("ceph_cluster_name")
    $munin_conf_dir           = lookup("munin_conf_dir")
    $munin_monitored          = lookup("ceph_munin")
    $munin_probes             = lookup("ceph_munin_probes")
    $munin_service_name       = lookup("munin_node_service_name")
    $nagios_ceph_client       = lookup("ceph_nagios_client")
    $nagios_ceph_keyring_path = lookup("ceph_nagios_keyring_path")
    $nagios_map               = lookup("ceph_nagios_map")
    $nagios_runtime_user      = lookup("nagios_runtime_user")
    $plugins_dir              = lookup("nagios_plugins_dir")
    $rdomain                  = lookup("root_domain")
    $sudo_conf_dir            = lookup("sudo_conf_dir")
    $version_codename         = lookup("ceph_version")
    $with_nagios              = lookup("ceph_nagios")

    if ($nagios_ceph_keyring_path != false) {
	$nagios_ceph_keyring = "$nagios_ceph_keyring_path/$cluster_name.client.$nagios_ceph_client.keyring"
    } else {
	$nagios_ceph_keyring = "/etc/ceph/$cluster_name.client.$nagios_ceph_client.keyring"
    }
}
