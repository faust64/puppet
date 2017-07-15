class common::config::timezone {
    $timezone = lookup("locale_tz")

    file {
	"Set localtime":
	    ensure => link,
	    force  => true,
	    path   => "/etc/localtime",
	    target => "/usr/share/zoneinfo/$timezone";
    }
}
