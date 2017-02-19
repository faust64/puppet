class asterisk::queues {
    $conf_dir = $asterisk::vars::conf_dir
    $queues   = $asterisk::vars::queues

    file {
	"Install Asterisk queues configuration":
	    content => template("asterisk/queues.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload queues configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queues.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Wipeout queues rules configuration":
	    content => "",
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload queues configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/queuerules.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }

    if ($queues) {
	create_resources(asterisk::define::queue, $queues)
    }
}
