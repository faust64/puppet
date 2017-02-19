class packages::camtrace {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "camtrace.$rdomain"
	$aliases = [ $reverse, "camtrace" ]
    } else {
	$reverse = false
	$aliases = [ "camtrace" ]
    }

    file {
	"Install camtrace repository root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/camtrace",
	    require => File["Prepare www directory"];
    }
}
