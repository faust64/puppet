class vim::openbsd {
    case $kernelversion {
	"6.0":      { $src = "http://ftp.nluug.nl/OpenBSD/6.0/packages/$architecture/vim-7.4.1467p1-no_x11.tgz" }
	"5.9":      { $src = "http://ftp.nluug.nl/OpenBSD/5.9/packages/$architecture/vim-7.4.900-no_x11.tgz" }
	"5.8":      { $src = "http://ftp.nluug.nl/OpenBSD/5.8/packages/$architecture/vim-7.4.769-no_x11.tgz" }
	"5.7":      { $src = "http://ftp.nluug.nl/OpenBSD/5.7/packages/$architecture/vim-7.4.475-no_x11.tgz" }
	"5.6":      { $src = "http://ftp.nluug.nl/OpenBSD/5.6/packages/$architecture/vim-7.4.135p2-no_x11.tgz" }
	"5.5":      { $src = "http://ftp.nluug.nl/OpenBSD/5.5/packages/$architecture/vim-7.4.135p0-no_x11.tgz" }
	"5.4":      { $src = "http://ftp.nluug.nl/OpenBSD/5.4/packages/$architecture/vim-7.3.850-no_x11.tgz" }
	/5\.[123]/: { $src = "http://ftp.nluug.nl/OpenBSD/$kernelversion/packages/$architecture/vim-7.3.154p2-no_x11.tgz" }
	"5.0":      { $src = "http://ftp.nluug.nl/OpenBSD/5.0/packages/$architecture/vim-7.3.154p1-no_x11.tgz" }
	"4.9":      { $src = "http://ftp.nluug.nl/OpenBSD/4.9/packages/$architecture/vim-7.3.3p1-no_x11.tgz" }
	default:    { notify { "patch needed: unsupported kernel version": } }
    }

    common::define::package {
	"vim":
	    source => $src;
    }
}
