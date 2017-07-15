class moin::config {
    $conf_dir       = $moin::vars::conf_dir
    $front_page     = $moin::vars::front_page
    $interwiki_name = $moin::vars::interwiki_name
    $lib_dir        = $moin::vars::lib_dir
    $mail_from      = $moin::vars::mail_from
    $mail_hub       = $moin::vars::mail_hub
    $runtime_group  = $moin::vars::runtime_group
    $runtime_user   = $moin::vars::runtime_user
    $site_name      = $moin::vars::site_name
    $superuser      = $moin::vars::superuser
    $underlay_dir   = $moin::vars::underlay_dir

    file {
	"Prepare MoinMoin for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Install MoinMoin main configuration":
	    content => template("moin/mywiki.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/mywiki.py",
	    require => File["Prepare MoinMoin for further configuration"];
	"Install MoinMoin farmconfig":
	    content => template("moin/farmconfig.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/farmconfig.py",
	    require => Exec["Move out initial farmconfig"];
	"Prepare MoinMoin lib directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $lib_dir,
	    require => File["Prepare MoinMoin for further configuration"];
    }

    exec {
	"Install lib data":
	    command => "cp -rp data $lib_dir/ && chown -R $runtime_user:$runtime_group $lib_dir /usr/share/moin/underlay",
	    creates => "$lib_dir/data",
	    cwd     => "/usr/share/moin",
	    path    => "/usr/bin:/bin",
	    require => File["Prepare MoinMoin lib directory"];
	"Move out initial farmconfig":	#avoid potential "invalid byte sequence in UTF-8"
	    command => "mv farmconfig.py farmconfig.py.orig",
	    creates => "$conf_dir/farmconfig.py.orig",
	    cwd     => $conf_dir,
	    path    => "/usr/bin:/bin",
	    require => File["Prepare MoinMoin for further configuration"];
    }
}
