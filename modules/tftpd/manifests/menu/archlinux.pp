class tftpd::menu::archlinux {
    $download = $tftpd::vars::download
    $root_dir = $tftpd::vars::root_dir

    file {
	"Prepare ArchLinux root directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$root_dir/installers/archlinux",
	    require => File["Prepare installers directory"];
    }

    exec {
	"Download ArchLinux ipxe.lkrn":
	    command => "$download https://releng.archlinux.org/pxeboot/ipxe.lkrn",
	    creates => "$root_dir/installers/archlinux/ipxe.lkrn",
	    cwd     => "$root_dir/installers/archlinux",
	    path    => "/usr/local/bin:/usr/bin:/bin",
	    require => File["Prepare ArchLinux root directory"];
    }
# ArchLinux uses some outdated version of ipxe.lkrn. Build your own:
# git clone git://git.ipxe.org/ipxe.git
# cd ipxe/src
# wget https://releng.archlinux.org/pxeboot/arch.ipxe
# (see ipxe site for dependencies list)
# make bin/ipxe.lkrn EMBED=arch.ipxe
}
