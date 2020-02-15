class vim::openbsd {
    if (versioncmp($kernelversion, '6.6') >= 0) {
	package {
	    "vim":
		flavor => "no_x11";
	}
    } else {
	case $kernelversion {
	    "6.0":      { $myname = "vim-7.4.1467p1-no_x11" }
	    "5.9":      { $myname = "vim-7.4.900-no_x11" }
	    "5.8":      { $myname = "vim-7.4.769-no_x11" }
	    "5.7":      { $myname = "vim-7.4.475-no_x11" }
	    "5.6":      { $myname = "vim-7.4.135p2-no_x11" }
	    "5.5":      { $myname = "vim-7.4.135p0-no_x11" }
	    "5.4":      { $myname = "vim-7.3.850-no_x11" }
	    /5\.[123]/: { $myname = "vim-7.3.154p2-no_x11" }
	    "5.0":      { $myname = "vim-7.3.154p1-no_x11" }
	    "4.9":      { $myname = "vim-7.3.3p1-no_x11" }
	    default:    { notify { "patch needed: unsupported os release": } }
	}

	common::define::package {
	    $myname:
	}
    }
}
