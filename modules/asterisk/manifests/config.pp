class asterisk::config {
    $conf_dir  = $asterisk::vars::conf_dir
    $data_dir  = $asterisk::vars::data_dir
    $lib_dir   = $asterisk::vars::lib_dir
    $run_dir   = $asterisk::vars::run_dir
    $spool_dir = $asterisk::vars::spool_dir
    $var_dir   = $asterisk::vars::var_dir

    file {
	"Install asterisk main configuration":
	    content => template("asterisk/asterisk.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/asterisk.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install asterisk adsi configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$asterisk::vars::service_name],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/asterisk.adsi",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/asterisk.adsi";
	"Install asterisk logger configuration":
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload logger configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/logger.conf",
	    require => File["Prepare Asterisk for further configuration"],
	    source  => "puppet:///modules/asterisk/logger.conf";
    }
}
