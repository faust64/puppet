define nodejs::define::module($app     = false,
			      $approot = "/etc/node/apps-available/$app") {
    if ($app != false) {
	exec {
	    "Install $name for $app":
		command => "npm install $name --save",
		cwd     => $approot,
		notify  => Service[$nodejs::vars::service_name],
		onlyif  => "test -d $approot",
		path    => "/usr/bin:/bin",
		unless  => "test -s $approot/node_modules/$name/package.json";
	}
    } else {
	if ($nodejs::vars::force_version == false) {
	    $nodepath = "/usr/local/lib/node_modules"
	} else {
	    $nodepath = "/usr/local/nodejs/lib/node_modules"
	}

	exec {
	    "Install $name globally":
		command => "npm install -g $name",
		cwd     => "/",
		path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
		unless  => "test -s $nodepath/$name/package.json";
	}
    }
}
