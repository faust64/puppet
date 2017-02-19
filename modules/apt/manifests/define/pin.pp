define apt::define::pin($pinvalue   = 900,
			$sourceattr = "o=Debian,a=stable") {
    if (! defined(Apt::Define::Pin["default"])) {
	apt::define::pin { "default": }
    }

    file {
	"Install $name apt pin preferences":
	    content => template("apt/pin.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/apt/preferences.d/$name",
	    require => File["Prepare APT preferences directory"];
    }
}
