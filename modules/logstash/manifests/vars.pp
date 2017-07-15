class logstash::vars {
    $download        = lookup("download_cmd")
    $do_relp         = lookup("logstash_do_relp")
    $do_tcp          = lookup("logstash_do_tcp")
    $do_udp          = lookup("logstash_do_udp")
    $esearch_version = lookup("elasticsearch_version")
    $nagios_user     = lookup("nagios_runtime_user")
    $output          = lookup("logstash_output")
    $relp_port       = lookup("logstash_relp_port")
    $runtime_group   = lookup("logstash_runtime_group")
    $runtime_user    = lookup("logstash_runtime_user")
    $tcp_port        = lookup("logstash_tcp_port")
    $udp_port        = lookup("logstash_udp_port")
    $version         = lookup("logstash_version")

    if (versioncmp($version, '5.0') < 0) {
	$geodb       = "GeoLiteCity.dat"
	$installpath = "/opt/logstash"
    } else {
	$geodb       = "GeoLite2-City.mmdb"
	$installpath = "/usr/share/logstash"
    }
    if (defined(Class[Ossec]) and lookup("ossec_manager") == false) {
	$do_ossec = true
    } else {
	$do_ossec = false
    }
}
