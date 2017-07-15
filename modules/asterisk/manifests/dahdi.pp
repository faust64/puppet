class asterisk::dahdi {
    $dahdi_conf = $asterisk::vars::dahdi_conf_dir
    $conf_dir   = $asterisk::vars::conf_dir
    $channels   = $asterisk::vars::dahdi_chans
    $locale     = $asterisk::vars::locale

    file {
	"Prepare Dahdi for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $dahdi_conf;
	"Install Dahdi driver modules loading configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["dahdi"],
	    owner   => root,
	    path    => "$dahdi_conf/modules",
	    require => File["Prepare Dahdi for further configuration"],
	    source  => "puppet:///modules/asterisk/dahdi_modules";
	"Install Dahdi driver configuration":
	    content => template("asterisk/dahdi_system.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["dahdi"],
	    owner   => root,
	    path    => "$dahdi_conf/system.conf",
	    require => File["Prepare Dahdi for further configuration"];
	"Install Asterisk Dahdi configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dahdi configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/chan_dahdi.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/chan_dahdi.conf";
	"Install Dahdi Channels configuration":
	    content => template("asterisk/dahdi_channels.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dahdi configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/dahdi-channels.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }

    File["Install Dahdi driver configuration"]
	-> File["Install Dahdi Channels configuration"]
	-> File["Install Asterisk Dahdi configuration"]
}
