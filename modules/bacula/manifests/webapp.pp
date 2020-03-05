class bacula::webapp {
    include apache

    $mysql_pass  = $bacula::vars::mysql_pass
    $rdomain     = $bacula::vars::rdomain
    $web_dir     = $bacula::vars::web_dir
    if ($domain != $rdomain) {
	$reverse = "bacula.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    file {
	"Prepare bacula-web site directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $web_dir;
	"Set proper permissions on Smarty cache":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => lookup("apache_runtime_user"),
	    path    => "$web_dir/application/view/cache",
	    require =>
		[
		    Class["apache"],
		    Exec["Install bacula-web"]
		];
	"Install bacula-web configuration":
	    content => template("bacula/web.erb"),
	    group   => lookup("apache_runtime_group"),
	    mode    => "0640",
	    owner   => root,
	    path    => "$web_dir/application/config/config.php",
	    require => File["Set proper permissions on Smarty cache"];
    }

    common::define::geturl {
	"bacula-web":
	    nomv    => true,
	    notify  => Exec["Install bacula-web"],
	    require => Class["php"],
	    target  => "/usr/src/bacula-web-latest.tgz",
	    url     => "http://www.bacula-web.org/files/bacula-web.org/downloads/bacula-web-latest.tgz",
	    wd      => "/usr/src";
    }

    exec {
	"Install bacula-web":
	    command     => "tar -xzf /usr/src/bacula-web-latest.tgz",
	    cwd         => $web_dir,
	    refreshonly => true,
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare bacula-web site directory"];
	"Install bacula-web docs":
	    command     => "mv $web_dir/docs bacula-web",
	    creates     => "/usr/share/doc/bacula-web",
	    cwd         => "/usr/share/doc",
	    path        => "/usr/bin:/bin",
	    require     => Exec["Install bacula-web"];
    }

    apache::define::vhost {
	"bacula.$domain":
	    aliases       => $aliases,
	    app_root      => $web_dir,
	    csp_name      => "baculaweb",
	    vhostldapauth => true,
	    with_reverse  => $reverse;
    }
}
