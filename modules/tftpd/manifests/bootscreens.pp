class tftpd::bootscreens {
    $download    = $tftpd::vars::download
    $locale      = $tftpd::vars::locale
    $locale_long = $tftpd::vars::locale_long
    $repo        = $tftpd::vars::repo
    $root_dir    = $tftpd::vars::root_dir
    $wds_ip      = $tftpd::vars::wds_ip

    file {
	"Install pxe main boot-screen":
	    content => template("tftpd/main.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/main.cfg",
	    require => File["Prepare boot-screens directory"];
	"Install tools boot-screen":
	    content => template("tftpd/tools.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/tools.cfg",
	    require => File["Prepare boot-screens directory"];
	"Install stdmenu boot-screen":
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/stdmenu.cfg",
	    require => File["Prepare boot-screens directory"],
	    source  => "puppet:///modules/tftpd/stdmenu.cfg";
    }

    exec {
	"Install splash.png":
	    command => "$download $repo/puppet/splash.png",
	    cwd     => "$root_dir/boot-screens",
	    path    => "/usr/bin:/bin",
	    require => File["Prepare boot-screens directory"],
	    unless  => "test -e splash.png";
    }
}
