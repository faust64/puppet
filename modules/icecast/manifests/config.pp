class icecast::config {
    $admin_pass  = $icecast::vars::admin_pass
    $admin_user  = $icecast::vars::admin_user
    $codir_pass  = $icecast::vars::codir_pass
    $codir_user  = $icecast::vars::codir_user
    $conf_dir    = $icecast::vars::conf_dir
    $log_dir     = $icecast::vars::log_dir
    $max_clients = $icecast::vars::max_clients
    $max_sources = $icecast::vars::max_sources
    $relay_pass  = $icecast::vars::relay_pass
    $relay_user  = $icecast::vars::relay_user
    $share_dir   = $icecast::vars::share_dir
    $upstream    = $icecast::vars::upstream

    file {
	"Prepare Icecast for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install Icecast main configuration":
	    content => template("icecast/icecast.erb"),
	    group   => $icecast::vars::runtime_group,
	    mode    => "0640",
	    notify  => Service[$icecast::vars::service_name],
	    owner   => root,
	    path    => "$conf_dir/icecast.xml",
	    require => Exec["Generate local codir authentication"];
	"Set local codir authentication permissions":
	    ensure  => present,
	    group   => $icecast::vars::runtime_group,
	    mode    => "0640",
	    owner   => root,
	    path    => "$conf_dir/myauth",
	    require => Exec["Generate local codir authentication"];
    }

    exec {
	"Generate local codir authentication":
	    command => "htpasswd -b -c myauth '$codir_user' '$codir_pass'",
	    cwd     => $conf_dir,
	    path    => "/usr/bin:/bin",
	    require => File["Prepare Icecast for further configuration"],
	    unless  => "test -e myauth";
    }
}
