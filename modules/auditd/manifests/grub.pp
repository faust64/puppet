class auditd::grub {
    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	common::define::lined {
	    "Set audit=1 to grub configuration":
		line    => 'GRUB_CMDLINE_LINUX="audit=1"',
		match   => '^GRUB_CMDLINE_LINUX=',
		notify  => Exec["Re-generate grub configuration"],
		path    => "/etc/default/grub",
		require => File["Ensure /etc/default/grub present"];
	}
    } else {
	notify { "fixme: auditd::grub": }
    }
}
