class asterisk::contextes {
    $conf_dir = $asterisk::vars::conf_dir
    $fax_from = $asterisk::vars::fax_from
    $fax_to   = $asterisk::vars::fax_to

    file {
	"Install Asterisk from* contextes":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/from.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/from.conf";
	"Install Asterisk apps configuration":
	    content => template("asterisk/apps.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/apps.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk macros":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/macros.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/macros.conf";
	"Install Asterisk misc contextes":
	    content => template("asterisk/misc.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/misc.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }
}
