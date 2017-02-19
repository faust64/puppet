class asterisk::phoneprov {
    $aastra_datefmt = $asterisk::vars::aastra_datefmt
    $aastra_lang    = $asterisk::vars::aastra_lang
    $aastra_tzcode  = $asterisk::vars::aastra_tzcode
    $aastra_tzfmt   = $asterisk::vars::aastra_tzfmt
    $aastra_tzname  = $asterisk::vars::aastra_tzname
    $asterisk_ip    = $ipaddress
    $charset        = $asterisk::vars::charset
    $conf_dir       = $asterisk::vars::conf_dir
    $cisco_lang     = $asterisk::vars::cisco_lang
    $do_syslog      = $asterisk::vars::phones_syslog
    $ntp_upstream   = $asterisk::vars::ntp_upstream
    $srv_root       = $asterisk::vars::webserver_root
    $syslog_host    = $asterisk::vars::syslog_host
    $tz             = $asterisk::vars::tz
    $vlan_sip       = $asterisk::vars::vlan_sip
    $vlan_users     = $asterisk::vars::vlan_users

    asterisk::define::sipaccount {
	"00000":
	    context  => "from-unauthenticated",
	    limit    => 200,
	    sippass  => "generic",
	    username => "00000";
    }

    asterisk::define::spa_line {
	[ "1", "2", "3" ]:
    }

    file {
	"Install generic Aastra configuration":
	    content => template("asterisk/aastra.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0644",
	    owner   => root,
	    path    => "$srv_root/aastra/aastra.cfg",
	    require => File["Prepare Aastra configuration directory"];
	"Install generic SPA303 configuration":
	    content => template("asterisk/spa303.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0644",
	    owner   => root,
	    path    => "$srv_root/cisco/spa303.cfg",
	    require => File["Prepare Linksys configuration directory"];
	"Install generic SPA504 configuration":
	    content => template("asterisk/spa504.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0644",
	    owner   => root,
	    path    => "$srv_root/cisco/spa504.cfg",
	    require => File["Prepare Linksys configuration directory"];
	"Install generic SPA942 configuration":
	    content => template("asterisk/spa942.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0644",
	    owner   => root,
	    path    => "$srv_root/cisco/spa942.cfg",
	    require => File["Prepare Linksys configuration directory"];
	"Install Asterisk generic phones context definition":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/phoneconfig.conf",
	    require =>
		[
		    Asterisk::Define::Sipaccount["00000"],
		    File["Prepare Asterisk for further configuration"],
		    File["Install Asterisk AGI generating phone configurations"]
		],
	    source  => "puppet:///modules/asterisk/phoneconfig.conf";
    }

    exec {
	"Update Aastra directory":
	    command     => "aastra_directory",
	    cwd         => "/",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Aastra configuration directory"],
	    unless      => "test -s $srv_root/aastra/repertoire";
    }

    File["Install Asterisk generic phones context definition"]
	-> File["Install Asterisk extensions main configuration"]
}
