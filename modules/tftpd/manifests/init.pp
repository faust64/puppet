class tftpd {
    include nginx
    include tftpd::vars

    case $myoperatingsystem {
	"Debian", "Devuan", "Ubuntu": {
	    include tftpd::debian
	}
	"OpenBSD": {
	    include tftpd::openbsd
	}
	default: {
	    common::define::patchneeded { "tftpd": }
	}
    }

    include tftpd::config
    include tftpd::menu::archlinux
    include tftpd::menu::centos
    include tftpd::menu::coreos
    include tftpd::menu::debian
    include tftpd::menu::devuan
    include tftpd::menu::fedora
    include tftpd::menu::freebsd
    include tftpd::menu::mfsbsd
    include tftpd::menu::openbsd
    include tftpd::menu::opensuse
    include tftpd::menu::redhat
    include tftpd::menu::ubuntu
    include tftpd::automate::kickstart
    include tftpd::automate::preseed
    include tftpd::bootscreens
    include tftpd::webapp
    include tftpd::scripts
    include tftpd::jobs
}
