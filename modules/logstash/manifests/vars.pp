class logstash::vars {
    $download        = hiera("download_cmd")
    $do_relp         = hiera("logstash_do_relp")
    $do_tcp          = hiera("logstash_do_tcp")
    $do_udp          = hiera("logstash_do_udp")
    $esearch_version = hiera("elasticsearch_version")
    $nagios_user     = hiera("nagios_runtime_user")
    $output          = hiera("logstash_output")
    $relp_port       = hiera("logstash_relp_port")
    $runtime_group   = hiera("logstash_runtime_group")
    $runtime_user    = hiera("logstash_runtime_user")
    $tcp_port        = hiera("logstash_tcp_port")
    $udp_port        = hiera("logstash_udp_port")
    $version         = hiera("logstash_version")

    if (versioncmp($version, '5.0') < 0) {
	$geodb       = "GeoLiteCity.dat"
	$installpath = "/opt/logstash"
    } else {
	$geodb       = "GeoLite2-City.mmdb"
	$installpath = "/usr/share/logstash"
    }
    if (defined(Class[Ossec]) and hiera("ossec_manager") == false) {
	$do_ossec = true
    } else {
	$do_ossec = false
    }
}
