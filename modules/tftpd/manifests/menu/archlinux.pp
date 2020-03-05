class tftpd::menu::archlinux {
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

    common::define::geturl {
	"ArchLinux ipxe.lkrn":
	    nomv    => true,
	    require => File["Prepare ArchLinux root directory"],
	    target  => "$root_dir/installers/archlinux/ipxe.lkrn",
	    url     => "https://releng.archlinux.org/pxeboot/ipxe.lkrn",
	    wd      => "$root_dir/installers/archlinux";
    }
# ArchLinux uses some outdated version of ipxe.lkrn. Build your own:
# git clone git://git.ipxe.org/ipxe.git
# cd ipxe/src
# wget https://releng.archlinux.org/pxeboot/arch.ipxe
# (see ipxe site for dependencies list)
# make bin/ipxe.lkrn EMBED=arch.ipxe
}
