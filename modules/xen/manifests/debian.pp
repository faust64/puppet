class xen::debian {
    $mem_max      = $xen::vars::mem_max
    $mem_reserved = $xen::vars::mem_reserved
    if ($lsbdistcodename == "xenial") {
	$xenvers = "-4.6"
    } elsif ($lsbdistcodename == "trusty" or $lsbdistcodename == "jessie") {
	$xenvers = "-4.4"
    } elsif ($lsbdistcodename == "wheezy") {
	$xenvers = "-4.1"
    } else { $xenvers = "" }

    common::define::package {
	[ "xen-utils$xenvers" , "xen-system-$architecture" ]:
    }

    file {
	"Set Xen defaults":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/xendomains",
	    require => File["Install xl configuration"],
	    source  => "puppet:///modules/xen/xendomains";
	"Set Xen toolstack":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/default/xen",
	    source  => "puppet:///modules/xen/toolstack";
    }

    common::define::lined {
	"Set Dom0 mem reservation":
	    line    => "GRUB_CMDLINE_XEN_DEFAULT='dom0_mem=${mem_reserved}M,max:${mem_max}M loglvl=all guest_loglvl=all'",
	    match   => '^GRUB_CMDLINE_XEN_DEFAULT=',
	    notify  => Exec["Re-generate grub configuration"],
	    path    => "/etc/default/grub",
	    require => File["Ensure /etc/default/grub present"];
    }
}
