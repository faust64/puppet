class asterisk::manager {
    $ami       = $asterisk::vars::ami
    $conf_dir  = $asterisk::vars::conf_dir
    $contact   = $asterisk::vars::contact
    $data_dir  = $asterisk::vars::data_dir
    $listen    = $asterisk::vars::ami_bind_addr
    $spool_dir = $asterisk::vars::spool_dir

    file {
	"Install Asterisk AMI configuration":
	    content => template("asterisk/manager.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload manager configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/manager.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }

    if ($ami) {
	if ($ami['agi'] != undef) {
	    include php

	    file {
		"Install asterisk phpagi configuration":
		    content => template("asterisk/phpagi.erb"),
		    group   => $asterisk::vars::runtime_group,
		    mode    => "0640",
		    notify  => Exec["Reload manager configuration"],
		    owner   => $asterisk::vars::runtime_user,
		    path    => "$conf_dir/phpagi.conf",
		    require => File["Prepare Asterisk for further configuration"];
	    }
	}

	create_resources(asterisk::define::mgraccount, $ami)
    }
}
