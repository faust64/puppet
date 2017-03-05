class openbox($dm             = "lightdm",
	      $with_fbi       = false,
	      $with_feh       = false,
	      $with_nitrogen  = false,
	      $with_unclutter = false) {
    include xorg
    include openbox::vars

    if ($dm == "lightdm") {
	include lightdm
    } elsif ($dm == "slim") {
	include slim
    }
    if ($with_nitrogen) {
	include nitrogen
    }

    case $myoperatingsystem {
	"CentOS", "RedHat": {
	    include openbox::rhel
	}
	"Debian", "Devuan", "Ubuntu": {
	    include openbox::debian
	}
	"FreeBSD": {
	    include openbox::freebsd
	}
	"OpenBSD": {
	    include openbox::openbsd
	}
	default: {
	    common::define::patchneeded { "openbox": }
	}
    }

    include openbox::config
}
