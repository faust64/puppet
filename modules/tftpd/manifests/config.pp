class tftpd::config {
    $pkghost  = $tftpd::vars::pxe_packages
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare pxe server root":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $root_dir;
	"Prepare pxelinux.cfg directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/pxelinux.cfg",
	    require => File["Prepare pxe server root"];
	"Prepare boot-screens directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/boot-screens",
	    require => File["Prepare pxe server root"];
	"Prepare installers directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers",
	    require => File["Prepare pxe server root"];
	"Drop /srv/tftp":
	    ensure  => absent,
	    force   => true,
	    path    => "/srv/tftp";
	"Install pxelinux.cfg default configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$root_dir/pxelinux.cfg/default",
	    require => File["Prepare pxelinux.cfg directory"],
	    source  => "puppet:///modules/tftpd/pxelinux-default";
    }

    common::define::geturl {
	"main pxelinux":
	    nomv    => true,
	    notify  => Exec["Copy main com32"],
	    require => File["Prepare pxe server root"],
	    target  => "$root_dir/pxelinux.0",
	    url     => "http://ftp.debian.org/debian/dists/stable/main/installer-i386/current/images/netboot/pxelinux.0",
	    wd      => $root_dir;
	"main pxechain.com":
	    nomv    => true,
	    require => File["Prepare pxe server root"],
	    target  => "$root_dir/pxechain.com",
	    url     => "http://$pkghost/pxe/pxechain.com",
	    wd      => $root_dir;
	"main memdisk":
	    nomv    => true,
	    require => File["Prepare pxe server root"],
	    target  => "$root_dir/memdisk",
	    url     => "http://$pkghost/pxe/memdisk",
	    wd      => $root_dir;
	"ultimate-boot-cd":
	    nomv    => true,
	    notify  => Exec["Extract UBCD"],
	    target  => "/root/ubcd-sources.tar.gz",
	    url     => "http://$pkghost/puppet/ubcd-sources.tar.gz",
	    wd      => "/root";
	"system-rescue-cd":
	    nomv    => true,
	    notify  => Exec["Extract SystemResueCD"],
	    target  => "/root/sysrcd-sources.tar.gz",
	    url     => "http://$pkghost/puppet/sysrcd-sources.tar.gz",
	    wd      => "/root";
    }

    exec {
#fixme: openbsd won't have corresponding package
	"Copy main com32":
	    command     => "cp -p ldlinux.c32 libutil.c32 libcom32.c32 vesamenu.c32 menu.c32 $root_dir/",
	    cwd         => "/usr/lib/syslinux/modules/bios",
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["syslinux"];
	"Extract UBCD":
	    command     => "tar -xzf /root/ubcd-sources.tar.gz",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare pxe server root"];
	"Extract SystemResueCD":
	    command     => "tar -xzf /root/sysrcd-sources.tar.gz",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare pxe server root"];
    }
}
