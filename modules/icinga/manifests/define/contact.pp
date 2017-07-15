define icinga::define::contact($aalias         = $name,
			       $doslack        = false,
			       $contact        = lookup("contact_alerts"),
			       $notify_options = "w,u,c,r",
			       $notify_period  = "24x7") {
    $conf_dir = $icinga::vars::nagios_conf_dir

    file {
	"Install Icinga $name contact configuration":
	    content => template("icinga/contact.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Exec["Refresh Icinga configuration"],
	    owner   => root,
	    path    => "$conf_dir/import.d/contact-$name.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
    }
}
