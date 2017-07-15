class logstash::nagios {
    file {
	"Ensure check_logstash input file owned by nagios":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => $logstash::vars::nagios_user,
	    path    => "/tmp/logstash_check.in",
	    require => File["Prepare logstash for further configuration"];
	"Ensure check_logstash output file owned by logstash":
	    ensure  => present,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => "logstash",
	    path    => "/tmp/logstash_check.out",
	    require => File["Prepare logstash for further configuration"];
    }

    nagios::define::probe {
	"logstash":
	    description   => "$fqdn Logstash status",
	    pluginargs    => [ "-w", "660", "-c", "1200" ],
	    require       =>
		[
		    File["Ensure check_logstash input file owned by nagios"],
		    File["Ensure check_logstash output file owned by logstash"]
		],
	    servicegroups => "system",
	    use           => "meh-service";
    }
}
