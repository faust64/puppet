define asterisk::define::spa_line($lineid = $name) {
    $srv_root = $asterisk::vars::webserver_root

    file {
	"Install generic SPA user line #$name configuration":
	    content => template("asterisk/spa_generic_line.erb"),
	    group   => $asterisk::vars::runtime_group,
	    mode    => "0640",
	    owner   => $asterisk::vars::config_user,
	    path    => "$srv_root/cisco/generic$lineid.cfg",
	    require => File["Prepare Linksys configuration directory"];
    }

    File["Install generic SPA user line #$name configuration"]
	-> File["Install generic SPA303 configuration"]
	-> File["Install generic SPA504 configuration"]
	-> File["Install generic SPA942 configuration"]
}
