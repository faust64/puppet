class asterisk::scripts {
    $asterisk_ip = $ipaddress
    $conf_dir    = $asterisk::vars::conf_dir
    $data_dir    = $asterisk::vars::data_dir
    $directory   = $asterisk::vars::aastra_directory
    $srv_root    = $asterisk::vars::webserver_root

    file {
	"Install phone pre-configuration script":
	    content => template("asterisk/phone_setup.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/phone_setup",
	    require => File["Prepare Linksys configuration directory"];
	"Install Asterisk AGI generating phone configurations":
	    content => template("asterisk/genconf.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0750",
	    owner   => root,
	    path    => "$data_dir/agi-bin/genconf.sh",
	    require => File["Prepare Asterisk AGI directory"];
	"Install asterisk trunks reloading main script":
	    content => template("asterisk/check_trunks.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    owner   => root,
	    path    => "/usr/local/sbin/check_trunks";
	"Install asterisk sip trunk reloading script":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/sip_edit",
	    source  => "puppet:///modules/asterisk/sip_edit";
	"Install asterisk iax trunk reloading script":
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/bin/trunk_edit",
	    source  => "puppet:///modules/asterisk/trunk_edit";
	"Install Aastra directory generation script":
	    content => template("asterisk/aastra_directory.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0750",
	    notify  => Exec["Update Aastra directory"],
	    owner   => root,
	    path    => "/usr/local/sbin/aastra_directory";
    }
}
