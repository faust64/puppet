class pnp4nagios::config {
    $conf_dir        = $pnp4nagios::vars::conf_dir
    $data_dir        = $pnp4nagios::vars::install_dir
    $lib_dir         = $pnp4nagios::vars::lib_dir
    $nagios_conf_dir = $pnp4nagios::vars::nagios_conf_dir
    $runtime_group   = $pnp4nagios::vars::runtime_group
    $runtime_user    = $pnp4nagios::vars::runtime_user
    $spool_dir       = $pnp4nagios::vars::spool_dir

    file {
	"Prepare pnp4nagios for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare pnp4nagios logs directory":
	    ensure  => directory,
	    owner   => $runtime_user,
	    path    => "/var/log/pnp4nagios",
	    require => File["Prepare pnp4nagios for further configuration"];
	"Install npcd main configuration":
	    content => template("pnp4nagios/npcd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service[$pnp4nagios::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/npcd.cfg",
	    require => File["Prepare pnp4nagios logs directory"];
	"Install pnp4nagios templates configurations":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$nagios_conf_dir/import.d/pnp4nagios-templates.cfg",
	    require => File["Prepare pnp4nagios for further configuration"],
	    source  => "puppet:///modules/pnp4nagios/templates.cfg";
	"Install pnp4nagios check_vzload plugin":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$data_dir/html/templates.dist/check_vzload.php",
	    require => File["Prepare pnp4nagios for further configuration"],
	    source  => "puppet:///modules/pnp4nagios/check_vzload.php";
	"Install pnp4nagios service_box view":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$data_dir/html/application/views/service_box.php",
	    require => File["Prepare pnp4nagios for further configuration"],
	    source  => "puppet:///modules/pnp4nagios/service_box.php";
    }
}
