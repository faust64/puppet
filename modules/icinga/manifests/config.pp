class icinga::config {
    include xinetd

    $cache_dir        = $icinga::vars::cache_dir
    $clients          = $icinga::vars::livestatus_clients
    $conf_dir         = $icinga::vars::conf_dir
    $contact_groups   = $icinga::vars::nagios_contact_groups
    $contacts         = $icinga::vars::nagios_contacts
    $dns_ip           = $icinga::vars::dns_ip
    $lib_dir          = $icinga::vars::lib_dir
    $nagios_conf_dir  = $icinga::vars::nagios_conf_dir
    $plugindir        = $icinga::vars::plugins_dir
    $runtime_user     = $icinga::vars::runtime_user
    $slack_hook_uri   = $icinga::vars::slack_hook_uri
    $sslscan_critical = $icinga::vars::sslscan_critical
    $sslscan_warning  = $icinga::vars::sslscan_warning

    icinga::define::config {
	"icinga.cfg":
	    notify  => Service["icinga"],
	    require =>
		[
		    File["Install Icinga commands configuration file"],
		    File["Install Icinga resource configuration file"],
		    File["Install Icinga generic host configuration"],
		    File["Install Icinga generic service configuration"],
		    File["Install Icinga generic timeperiods configuration"],
		    File["Prepare Icinga cache directory"],
		    File["Prepare Icinga lib directory"],
		    File["Prepare Icinga logs directory"],
		    File["Prepare Icinga run directory"]
		];
	"icinga-check-puppet.cfg":
	    probes  => "import.d",
	    require =>
		[
		    File["Link Icinga Import directory to generic localtion"],
		    File["Prepare Icinga cache directory"],
		    File["Prepare Icinga lib directory"],
		    File["Prepare Icinga logs directory"],
		    File["Prepare Icinga run directory"]
		];
    }

    file {
	"Install Livestatus xinetd configuration":
	    content => template("icinga/xinetd.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$icinga::vars::xinetd_service_name],
	    owner   => root,
	    path    => "/etc/xinetd.d/livestatus",
	    require => File["Prepare Xinetd for further configuration"];
	"Install Icinga commands configuration file":
	    content => template("icinga/commands.erb"),
	    group   => nagios,
	    mode    => "0640",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "$conf_dir/commands.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Install Icinga resource configuration file":
	    content => template("icinga/resource.erb"),
	    group   => $icinga::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "$conf_dir/resource.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Link Icinga Import directory to generic localtion":
	    ensure  => link,
	    force   => true,
	    path    => "$conf_dir/import.d",
	    require =>
		[
		    File["Prepare nagios hosts probes import directory"],
		    File["Prepare nagios services probes import directory"],
		    File["Prepare nagios service-dependencies probes import directory"],
		    File["Prepare nagios service-escalations probes import directory"],
		    File["Prepare nagios static probes import directory"]
		],
	    target  => "$nagios_conf_dir/import.d";
	"Install devices querying configuration":
	    content => template("icinga/check_devices.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "/etc/nagios-plugins/config/check_devices.cfg",
	    require => File["Install check_nrpe plugin configuration"];
	"Install check_nrpe plugin configuration":
	    content => template("icinga/check_nrpe.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "/etc/nagios-plugins/config/check_nrpe.cfg";
    }
}
