define icinga::define::serviceclass($check_interval        = 1440,
				    $contacts              = "root",
				    $inherits              = "generic",
				    $max_check_attempts    = 16,
				    $notification_interval = 4320,
				    $retry_check_interval  = 20,
				    $timeperiod            = "24x7") {
    $conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Install Icinga $name service class declaration":
	    content => template("icinga/service.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/serviceclass_$name.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
    }
}
