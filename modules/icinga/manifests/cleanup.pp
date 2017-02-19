class icinga::cleanup {
    $conf_dir = $icinga::vars::conf_dir
    $web_conf = $icinga::vars::apache_conf_dir

    file {
	"Drop Icinga default extinfo configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/extinfo_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga default contacts configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/contacts_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga default hostgroups configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/hostgroups_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga localhost declaration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/localhost_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga local services declaration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/services_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga default timeperiods declaration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/timeperiods_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga generic host configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/generic-host_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga generic service configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/objects/generic-service_icinga.cfg",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga default vhost configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service["icinga"],
	    path    => "$conf_dir/apache2.conf",
	    require => File["Prepare Icinga imported configuration directory"];
	"Drop Icinga malicious inclusion":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$icinga::vars::web_service],
	    path    => "$web_conf/conf.d/icinga.conf",
	    require => Package["icinga"];
    }
}
