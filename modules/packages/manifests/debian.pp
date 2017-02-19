class packages::debian {
    $rdomain  = $packages::vars::rdomain
    $web_root = $packages::vars::web_root
    if ($domain != $rdomain) {
	$reverse = "debian.$rdomain"
	$aliases = [ $reverse, "debian", "ubuntu.$domain", "ubuntu.$rdomain", "ubuntu" ]
    } else {
	$reverse = false
	$aliases = [ "debian", "ubuntu.$domain", "ubuntu" ]
    }

    file {
	"Install debian repository root":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/debian",
	    require => File["Prepare www directory"];
	"Install debian repository configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/debian/conf",
	    require => File["Install debian repository root"];

	"Install debian repository public key":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/debian/public.key",
	    require => File["Install debian repository root"],
	    source  => "puppet:///modules/packages/public.key";

	"Install debian repository distributions configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/debian/conf/distributions",
	    require => File["Install debian repository configuration directory"],
	    source  => "puppet:///modules/packages/distributions";
	"Install debian repository options configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$web_root/debian/conf/options",
	    require => File["Install debian repository configuration directory"],
	    source  => "puppet:///modules/packages/options";
    }

    if (defined(Class[Apache])) {
	apache::define::vhost {
	    "debian.$domain":
		aliases      => $aliases,
		app_root     => "$web_root/debian",
		csp_name     => "packages",
		pubclear     => true,
		require      => File["Install debian repository root"],
		with_reverse => $reverse;
	}
    } else {
	nginx::define::vhost {
	    "debian.$domain":
		aliases        => $aliases,
		app_root       => "$web_root/debian",
		autoindex      => true,
		csp_name       => "packages",
		noerrors       => true,
		nohttpsrewrite => true,
		pubclear       => true,
		require        => File["Install debian repository root"],
		with_reverse   => $reverse;
	}
    }
}
