class packages::bios {
    $web_root = $packages::vars::web_root

    file {
	"Install bios repository root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/bios",
	    require => File["Prepare www directory"];
	"Install Desktops bios repository":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/bios/Desktops",
	    require => File["Install bios repository root"];
	"Install Laptops bios repository":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/bios/Laptops",
	    require => File["Install bios repository root"];
	"Install Servers bios repository":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$web_root/bios/Servers",
	    require => File["Install bios repository root"];
    }
}
