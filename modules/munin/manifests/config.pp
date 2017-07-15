class munin::config {
    $conf_dir = $munin::vars::munin_conf_dir
    $web_root = $munin::vars::web_root

    file {
	"Setup munin web root":
	    ensure  => directory,
	    group   => $munin::vars::munin_group,
	    mode    => "0755",
	    owner   => $munin::vars::munin_user,
	    path    => "$web_root/munin";
	"Install munin default configuration":
	    content => template("munin/munin.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/munin.conf",
	    require => File["Prepare Munin for further configuration"];
	"Prepare munin supervised hosts directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/munin-conf.d",
	    require => File["Prepare Munin for further configuration"];
    }
}
