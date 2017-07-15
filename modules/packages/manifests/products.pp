class packages::products {
    $web_root = $packages::vars::web_root

    file {
	"Install products repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/products",
	    require => File["Prepare www directory"];
    }
}
