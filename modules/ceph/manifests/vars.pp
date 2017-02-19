class ceph::vars {
    $apache_runtime_user      = hiera("apache_runtime_user")
    $apache_service           = hiera("apache_service_name")
    $dash_client              = hiera("ceph_dashboard_client_name")
    $dash_keyring             = hiera("ceph_dashboard_client_keyring")
    $do_dashboard             = hiera("ceph_do_dashboard")
    $cluster_name             = hiera("ceph_cluster_name")
    $munin_conf_dir           = hiera("munin_conf_dir")
    $munin_monitored          = hiera("ceph_munin")
    $munin_probes             = hiera("ceph_munin_probes")
    $munin_service_name       = hiera("munin_node_service_name")
    $nagios_ceph_client       = hiera("ceph_nagios_client")
    $nagios_ceph_keyring_path = hiera("ceph_nagios_keyring_path")
    $nagios_map               = hiera("ceph_nagios_map")
    $nagios_runtime_user      = hiera("nagios_runtime_user")
    $plugins_dir              = hiera("nagios_plugins_dir")
    $rdomain                  = hiera("root_domain")
    $sudo_conf_dir            = hiera("sudo_conf_dir")
    $version_codename         = hiera("ceph_version")
    $with_nagios              = hiera("ceph_nagios")

    if ($nagios_ceph_keyring_path != false) {
	$nagios_ceph_keyring = "$nagios_ceph_keyring_path/$cluster_name.client.$nagios_ceph_client.keyring"
    } else {
	$nagios_ceph_keyring = "/etc/ceph/$cluster_name.client.$nagios_ceph_client.keyring"
    }
}
