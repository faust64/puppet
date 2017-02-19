class asterisk::extensions {
    $array_dom        = split($domain, '\.')
    $common_routes    = $asterisk::vars::common_routes
    $conf_dir         = $asterisk::vars::conf_dir
    $conference_rooms = $asterisk::vars::conference_rooms
    $extensions       = $asterisk::vars::extensions
    $here             = $array_dom[0]
    $iax_trunks       = $asterisk::vars::iax_trunks
    $lib_dir          = $asterisk::vars::lib_dir
    $local_routes     = $asterisk::vars::local_routes
    $locale           = $asterisk::vars::locale
    $pickup_contexts  = $asterisk::vars::pickup_contexts
    $queues           = $asterisk::vars::queues
    $ring_groups      = $asterisk::vars::ring_groups
    $run_dir          = $asterisk::vars::run_dir
    $sip_trunks       = $asterisk::vars::sip_trunks
    $spool_dir        = $asterisk::vars::spool_dir
    $time_conditions  = $asterisk::vars::time_conditions
    $var_dir          = $asterisk::vars::var_dir
    $vm_pass          = $asterisk::vars::default_vm_pass

    file {
	"Install Asterisk runtime variables configuration":
	    content => template("asterisk/vars.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/vars.conf",
	    require => File["Prepare Asterisk for further configuration"];
	"Install Asterisk extensions main configuration":
	    content => template("asterisk/extensions.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/extensions.conf",
	    require => File["Install Asterisk runtime variables configuration"];
	"Install Asterisk extensions pickup configuration":
	    content => template("asterisk/pickup.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    notify  => Exec["Reload dialplan configuration"],
	    owner   => $asterisk::vars::runtime_user,
	    path    => "$conf_dir/pickup.conf",
	    require => File["Prepare Asterisk for further configuration"];
    }

    if ($extensions) {
	create_resources(asterisk::define::extension, $extensions)
    }
    if ($ring_groups) {
	create_resources(asterisk::define::ringgroup, $ring_groups)
    }
    if ($time_conditions) {
	create_resources(asterisk::define::timecondition, $time_conditions)
    }
    if ($conference_rooms) {
	create_resources(asterisk::define::confroom, $conference_rooms)
    }
    if ($common_routes) {
	create_resources(asterisk::define::route, $common_routes)
    }
    if ($local_routes) {
	create_resources(asterisk::define::route, $local_routes)
    }
}
