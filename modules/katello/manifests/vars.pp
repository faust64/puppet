class katello::vars {
    $ak                 = lookup("katello_register_with_ak")
    $admin_password     = lookup("katello_admin_password")
    $admin_user         = lookup("katello_admin_user")
    $foreman_fqdn       = lookup("foreman_fqdn")
    $katello_loc        = lookup("katello_location")
    $katello_org        = lookup("katello_organization")
    $katello_version    = lookup("katello_version")
    $katello_versions   = lookup("katello_versions")
    $ks_password        = lookup("katello_ks_password")
    $manifest           = lookup("katello_manifest")
    $munin_conf_dir     = lookup("munin_conf_dir")
    $munin_monitored    = lookup("katello_munin_monitored")
    $munin_probes       = lookup("katello_munin_probes")
    $munin_service_name = lookup("munin_node_service_name")
    $ocpimages          = lookup("katello_docker_ocp_images")
    $pulp_workers_count = lookup("pulp_workers_count")
    $puppet_master      = lookup("puppetmaster")
    $rhregistry_pass    = lookup("rhregistry_authpass")
    $rhregistry_user    = lookup("rhregistry_authuser")

    $foreman_url        = "https://$foreman_fqdn"
    $katello_services   = $katello_versions[$katello_version]['services']
    $pulp_version       = $katello_versions[$katello_version]['pulp']
    $theforeman_version = $katello_versions[$katello_version]['foreman']

    $patches   =
	[ { file => "kickstart",
	    kind => "provision" },
	  { file => "puppet.conf",
	    kind => "snippet" },
	  { file => "puppet_setup",
	    kind => "snippet" } ]
    $sat_vers  = "6.7"
}
