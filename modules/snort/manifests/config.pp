class snort::config {
    $conf_dir     = $snort::vars::conf_dir
    $daq_dir      = $snort::vars::daq_dir
    $dns_ip       = $snort::vars::dns_ip
    $ignore_tcp   = $snort::vars::ignore_tcp
    $ignore_udp   = $snort::vars::ignore_udp
    $mail_ip      = $snort::vars::mail_ip
    $netids       = $snort::vars::netids

    file {
	"Prepare Snort for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Snort rules directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/rules",
	    require => File["Prepare Snort for further configuration"];
	"Prepare Snort logs directory":
	    ensure  => directory,
	    group   => $snort::vars::snort_group,
	    mode    => "0711",
	    owner   => $snort::vars::snort_user,
	    path    => $snort::vars::log_dir;
	"Install Snort main configuration":
	    content => template("snort/snort.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["snort"],
	    owner   => root,
	    path    => "$conf_dir/snort.conf",
	    require => File["Prepare Snort for further configuration"];
	"Install Snort local configuration":
	    content => template("snort/default_rules.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["snort"],
	    owner   => root,
	    path    => "$conf_dir/rules/local.rules",
	    require => File["Prepare Snort rules directory"];
    }

    if ($snort::vars::log_dir != "/var/log/snort") {
	file {
	    "Link Snort logs to /var/log":
		ensure  => link,
		force   => true,
		path    => "/var/log/snort",
		require => File["Prepare Snort logs directory"],
		target  => $snort::vars::log_dir;
	}

	File["Link Snort logs to /var/log"]
	    -> Common::Define::Service["snort"]
    }
}
