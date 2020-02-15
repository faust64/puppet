class packages {
    if (lookup("packages_is_apache")) {
	include apache
    } else {
	include nginx
    }
    include packages::vars
    include packages::tools
    include packages::bios
    include packages::camtrace
    include packages::debian
    include packages::elastix
    include packages::freebsd
    include packages::products
    include packages::lxc
    include packages::openbsd
    include packages::rhel
    include packages::sles
    include packages::wpad
    include packages::default
}
