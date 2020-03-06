class sickbeard::debian {
    $conf_dir     = $sickbeard::vars::conf_dir
    $data_dir     = $sickbeard::vars::data_dir
    $home_dir     = $sickbeard::vars::home_dir
    $run_dir      = $sickbeard::vars::run_dir
    $runtime_user = $sickbeard::vars::runtime_user

    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    file {
	"Install sickbeard init script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  => Service["sickbeard"],
	    owner   => root,
	    path    => "/etc/init.d/sickbeard",
	    source  => "puppet:///modules/sickbeard/debian.rc",
	    require => Git::Define::Clone["sickbeard"];
	"Install sickbeard service defaults":
	    content => template("sickbeard/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["sickbeard"],
	    owner   => root,
	    path    => "/etc/default/sickbeard";
    }

    File["Install sickbeard init script"]
	-> File["Install sickbeard service defaults"]
	-> File["Prepare sickbeard for further configuration"]
	-> Common::Define::Service["sickbeard"]
}
