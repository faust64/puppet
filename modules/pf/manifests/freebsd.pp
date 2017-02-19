class pf::freebsd {
    file_line {
	"Enable PF on boot":
	    line => 'pf_load="YES"',
	    path => '/boot/loader.conf';
    }
}
