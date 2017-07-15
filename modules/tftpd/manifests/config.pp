class tftpd::config {
    $download = $tftpd::vars::download
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

    exec {
	"Download main pxelinux":
	    command     => "$download http://ftp.debian.org/debian/dists/stable/main/installer-i386/current/images/netboot/pxelinux.0",
	    creates     => "$root_dir/pxelinux.0",
	    cwd         => $root_dir,
	    notify      => Exec["Copy main com32"],
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => File["Prepare pxe server root"];
#fixme: openbsd won't have corresponding package
	"Copy main com32":
	    command     => "cp -p ldlinux.c32 libutil.c32 libcom32.c32 vesamenu.c32 menu.c32 $root_dir/",
	    cwd         => "/usr/lib/syslinux/modules/bios",
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => Package["syslinux"];
	"Install main pxechain.com":
	    command     => "$download http://$pkghost/pxe/pxechain.com",
	    creates     => "$root_dir/pxechain.com",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => File["Prepare pxe server root"];
	"Install main memdisk":
	    command     => "$download http://$pkghost/pxe/memdisk",
	    creates     => "$root_dir/memdisk",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => File["Prepare pxe server root"];
	"Download ultimate-boot-cd":
	    command     => "$download http://$pkghost/puppet/ubcd-sources.tar.gz",
	    creates     => "/root/ubcd-sources.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract UBCD"],
	    path        => "/usr/local/bin:/usr/bin:/bin";
	"Extract UBCD":
	    command     => "tar -xzf /root/ubcd-sources.tar.gz",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare pxe server root"];
	"Download system-rescue-cd":
	    command     => "$download http://$pkghost/puppet/sysrcd-sources.tar.gz",
	    creates     => "/root/sysrcd-sources.tar.gz",
	    cwd         => "/root",
	    notify      => Exec["Extract SystemResueCD"],
	    path        => "/usr/local/bin:/usr/bin:/bin";
	"Extract SystemResueCD":
	    command     => "tar -xzf /root/sysrcd-sources.tar.gz",
	    cwd         => $root_dir,
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare pxe server root"];
    }
}
