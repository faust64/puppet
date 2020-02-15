class packages::asterisk {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "asterisk.$rdomain"
	$aliases = [ $reverse, "asterisk" ]
    } else {
	$reverse = false
	$aliases = [ "asterisk" ]
    }

    file {
	"Install asterisk repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/asterisk",
	    require => File["Prepare www directory"];
	"Install asterisk sync script":
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/usr/local/sbin/sync_asterisk",
	    source  => "puppet:///modules/packages/sync_asterisk";
    }

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "asterisk.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/asterisk",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install asterisk repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "asterisk.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/asterisk",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install asterisk repository root"],
		with_reverse   => $reverse;
	}
    }
}
