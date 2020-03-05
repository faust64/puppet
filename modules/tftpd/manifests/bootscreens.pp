class tftpd::bootscreens {
    $locale      = $tftpd::vars::locale
    $locale_long = $tftpd::vars::locale_long
    $repo        = $tftpd::vars::repo
    $rhrepo      = $tftpd::vars::rhrepo
    $root_dir    = $tftpd::vars::root_dir
    $wds_ip      = $tftpd::vars::wds_ip

    file {
	"Install pxe main boot-screen":
	    content => template("tftpd/main.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/main.cfg",
	    require => File["Prepare boot-screens directory"];
	"Install tools boot-screen":
	    content => template("tftpd/tools.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/tools.cfg",
	    require => File["Prepare boot-screens directory"];
	"Install stdmenu boot-screen":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/boot-screens/stdmenu.cfg",
	    require => File["Prepare boot-screens directory"],
	    source  => "puppet:///modules/tftpd/stdmenu.cfg";
    }

    common::define::geturl {
	"Install splash.png":
	    nomv    => true,
	    require => File["Prepare boot-screens directory"],
	    target  => "$root_dir/boot-screens/splash.png",
	    url     => "$$repo/puppet/splash.png",
	    wd      => "$root_dir/boot-screens";
    }
}
