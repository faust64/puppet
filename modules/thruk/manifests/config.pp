class thruk::config {
    $admin_contact = $thruk::vars::admin_contact
    $backends      = $thruk::vars::backends
    $conf_dir      = $thruk::vars::conf_dir
    $home_link     = $thruk::vars::home_link
    $runtime_group = $thruk::vars::runtime_group
    $runtime_user  = $thruk::vars::runtime_user
    $with_icinga   = $thruk::vars::with_icinga
    $with_shinken  = $thruk::vars::with_shinken

    thruk::define::plugin {
	$thruk::vars::plugins_drop:
	    enabled => false;
	$thruk::vars::plugins:
    }

    file {
	"Prepare Thruk for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare Thruk plugins configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/plugins",
	    require => File["Prepare Thruk for further configuration"];
	"Prepare Thruk plugins-available configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/plugins/plugins-available",
	    require => File["Prepare Thruk plugins configuration directory"];
	"Prepare Thruk plugins-enabled configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/plugins/plugins-enabled",
	    require => File["Prepare Thruk plugins configuration directory"];

	"Install Thruk CGI configuration":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["thruk"],
	    owner   => root,
	    path    => "$conf_dir/cgi.cfg",
	    require => File["Prepare Thruk for further configuration"],
	    source  => "puppet:///modules/thruk/cgi.cfg";
	"Install Thruk local configuration":
	    content => template("thruk/local.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["thruk"],
	    owner   => root,
	    path    => "$conf_dir/thruk_local.conf",
	    require => File["Install Thruk CGI configuration"];
	"Install Thruk main configuration":
	    content => template("thruk/thruk.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Service["thruk"],
	    owner   => root,
	    path    => "$conf_dir/thruk.conf",
	    require => File["Install Thruk local configuration"];
    }
}
