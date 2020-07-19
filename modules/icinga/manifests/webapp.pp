class icinga::webapp {
    if (! defined(Class["apache"])) {
	include apache
    }

    $conf_dir     = $icinga::vars::conf_dir
    $contacts     = $icinga::vars::nagios_contacts
    $lib_dir      = $icinga::vars::lib_dir
    $plugindir    = $icinga::vars::plugins_dir
    $rdomain      = $icinga::vars::rdomain
    $repo         = $icinga::vars::repo
    $share_dir    = $icinga::vars::share_dir
    $short_domain = $icinga::vars::short_domain
    $web_dir      = $icinga::vars::apache_conf_dir

    if ($domain != $rdomain) {
	$reverse     = "icinga.$rdomain"
	if ($hostname == "icinga") {
	    $aliases = [ $reverse, "monitor.$rdomain", "monitor.$domain" ]
	} else {
	    $aliases = [ $reverse, "monitor.$rdomain", "icinga.$domain" ]
	}
    } else {
	$reverse     = false
	if ($hostname == "icinga") {
	    $aliases = [ "monitor.$rdomain", "monitor.$domain" ]
	} else {
	    $aliases = [ "monitor.$rdomain", "icinga.$domain" ]
	}
    }

    if ($icinga::vars::pnp == true) {
	file {
	    "Install Icinga pnp lib dir":
		ensure => directory,
		group   => $icinga::vars::runtime_group,
		mode    => "0755",
		owner   => $icinga::vars::runtime_user,
		path    => "/var/lib/pnp4nagios/perfdata",
		recurse => true;
	    "Install Icinga pnp popup SSI":
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "$share_dir/htdocs/ssi/status-header.ssi",
		require => File["Prepare Icinga htdocs directory"],
		source  => "puppet:///modules/icinga/pnp.ssi";
	}
    }

    file {
	"Install Icinga CGI configuration":
	    content => template("icinga/cgi.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["icinga"],
	    owner   => root,
	    path    => "$conf_dir/cgi.cfg",
	    require => File["Prepare Icinga imported configuration directory"];

	"Install Icinga rw directory":
	    ensure  => directory,
	    group   => $icinga::vars::web_group,
	    mode    => "02710",
	    owner   => $icinga::vars::runtime_user,
	    path    => "$lib_dir/rw",
	    require => File["Prepare Icinga lib directory"];
	"Set permissions to icinga socket file":
	    group   => $icinga::vars::web_group,
	    mode    => "0660",
	    owner   => $icinga::vars::runtime_user,
	    path    => "$lib_dir/rw/icinga.cmd",
	    require => File["Install Icinga rw directory"];

	"Install Icinga cgi logs directory":
	    ensure  => directory,
	    group   => $icinga::vars::web_group,
	    mode    => "0755",
	    owner   => $icinga::vars::web_user,
	    path    => "$share_dir/htdocs/log",
	    require => Package["icinga"];
    }

    apache::define::vhost {
	"monitor.$domain":
	    aliases      => $aliases,
	    app_root     => "$share_dir/htdocs",
	    deny_frames  => "remote",
	    csp_name     => "icinga",
	    vhostsource  => "icinga",
	    with_reverse => $reverse;
    }
}
