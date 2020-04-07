define katello::define::globalparam($ensure = "present",
				    $type   = "string",
				    $value  = "",
				    $var    = $name) {
    if ($ensure == "present") {
	if ($type == 'string' or $type == 'boolean' or $type == 'integer'
	    or $type == 'real' or $type == 'array' or $type == 'hash'
	    or $type == 'yaml' or $type == 'json') {
	    exec {
		"Install Global Parameter $name":
		    command     => "hammer global-parameter set --name '$var' --parameter-type $type --value '$value'",
		    environment => [ 'HOME=/root' ],
		    path        => "/usr/bin:/bin",
		    require     => File["Install hammer cli configuration"],
		    unless      => "hammer global-parameter list | grep -E '^$var *\\| $value .*\\| $type'";
	    }
	} else {
	    notify {
		"Invalid Global Parameter $name":
		    message => "Invalid type $type";
	    }
	}
    } else {
	exec {
	    "Drop Global Parameter $name":
		command     => "hammer global-parameter delete --name '$var'",
		environment => [ 'HOME=/root' ],
		onlyif      => "hammer global-parameter list | grep '^$var '",
		path        => "/usr/bin:/bin",
		require     => File["Install hammer cli configuration"];
	}
    }
}
