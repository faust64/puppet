class logstash::config {
    $do_ossec      = $logstash::vars::do_ossec
    $do_relp       = $logstash::vars::do_relp
    $do_tcp        = $logstash::vars::do_tcp
    $do_udp        = $logstash::vars::do_udp
    $geodb         = $logstash::vars::geodb
    $output        = $logstash::vars::output
    $relp_port     = $logstash::vars::relp_port
    $runtime_group = $logstash::vars::runtime_group
    $runtime_user  = $logstash::vars::runtime_user
    $tcp_port      = $logstash::vars::tcp_port
    $udp_port      = $logstash::vars::udp_port
    $version       = $logstash::vars::version

    file {
	"Prepare logstash for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/logstash";
	"Prepare logstash configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/logstash/conf.d",
	    require => File["Prepare logstash for further configuration"];
	"Install Logstash custom patterns":
	    group   => hiera("gid_zero"),
	    ignore  => [ ".svn", ".git" ],
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/logstash/patterns",
	    require => File["Prepare logstash configuration directory"],
	    recurse => true,
	    source  => "puppet:///modules/logstash/patterns";
	"Install Logstash logs directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    notify  => Service["logstash"],
	    owner   => $runtime_user,
	    path    => "/var/log/logstash",
	    require => File["Prepare logstash for further configuration"];
	"Install Logstash main configuration":
	    content => template("logstash/config.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["logstash"],
	    owner   => root,
	    path    => "/etc/logstash/conf.d/logstash.conf",
	    require => File["Install Logstash custom patterns"];
    }
}
