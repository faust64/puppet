class common::config::grub {
    $grub_admins = hiera("grub_admin_users")

    case $operatingsystem {
	"CentOS", "Debian", "RedHat", "Ubuntu": {
# one of my oldest XEN PV had no grub:
# /etc/grub.d from grub-common
# /usr/sbin/update-grub from grub2-common
	    common::define::package {
		[ "grub-common", "grub2-common" ]:
	    }
	}
    }

    exec {
	"Re-generate grub configuration":
	    command     => "update-grub",
	    cwd         => "/",
	    refreshonly => true,
	    path        => "/usr/sbin:/usr/bin:/sbin:/bin";
    }

    file {
	"Set proper permissions to /boot/grub/grub.cfg":
	    ensure  => present,
	    group   => hiera("gid_zero"),
	    mode    => "0440",
	    owner   => root,
	    path    => "/boot/grub/grub.cfg";
    }

    if ($operatingsystem == "Debian" or $operatingsystem == "Ubuntu") {
	file {
	    "Ensure /etc/default/grub present":
		ensure => present,
		group  => hiera("gid_zero"),
		mode   => "0644",
		owner  => root,
		path   => "/etc/default/grub";
	}

	if ($operatingsystem == "Ubuntu" and $lsbdistcodename == "trusty") {
	    common::define::lined {
		"Drop GRUB_HIDDEN_TIMEOUT from grub defaults":
		    line    => '#GRUB_HIDDEN_TIMEOUT=0',
		    match   => '^GRUB_HIDDEN_TIMEOUT=',
		    notify  => Exec["Re-generate grub configuration"],
		    path    => "/etc/default/grub",
		    require => File["Ensure /etc/default/grub present"];
		"Drop GRUB_HIDDEN_TIMEOUT_QUIET from grub defaults":
		    line    => '#GRUB_HIDDEN_TIMEOUT_QUIET=true',
		    match   => '^GRUB_HIDDEN_TIMEOUT_QUIET=',
		    notify  => Exec["Re-generate grub configuration"],
		    path    => "/etc/default/grub",
		    require => File["Ensure /etc/default/grub present"];
		"Set GRUB_TIMEOUT_STYLE to grub defaults":
		    line    => 'GRUB_TIMEOUT_STYLE=countdown',
		    match   => 'GRUB_TIMEOUT_STYLE=',
		    notify  => Exec["Re-generate grub configuration"],
		    path    => "/etc/default/grub",
		    require => File["Ensure /etc/default/grub present"];
	    }

	    Common::Define::Lined["Drop GRUB_HIDDEN_TIMEOUT from grub defaults"]
		-> Common::Define::Lined["Drop GRUB_HIDDEN_TIMEOUT_QUIET from grub defaults"]
		-> Common::Define::Lined["Set GRUB_TIMEOUT_STYLE to grub defaults"]
		-> File["Set proper permissions to /boot/grub/grub.cfg"]
	}
	if ($operatingsystem == "Ubuntu" and $srvtype != "xen") {
	    $do     = "Install"
	    $ensure = "present"

	    common::define::lined {
		"Ensure default kernel boot isn't password-protected":
		    line    => 'CLASS="--class gnu-linux --class gnu --class os --unrestricted"',
		    match   => '^CLASS="--class gnu-linux --class gnu --class os',
		    notify  => Exec["Re-generate grub configuration"],
		    path    => "/etc/grub.d/10_linux";
		"Disable consoleblank":
		    line    => 'GRUB_CMDLINE_LINUX_DEFAULT="quiet splash consoleblank=0"',
		    match   => '^GRUB_CMDLINE_LINUX_DEFAULT=',
		    notify  => Exec["Re-generate grub configuration"],
		    path    => "/etc/default/grub",
		    require => File["Ensure /etc/default/grub present"];
	    }

	    Package["grub-common"]
		-> Package["grub2-common"]
		-> Common::Define::Lined["Ensure default kernel boot isn't password-protected"]
		-> File["$do grub password configuration"]
	} else {
	    $do     = "Drop"
	    $ensure = "absent"

	    common::define::lined {
		"Rollback default kernel boot isn't password-protected":
		    line   => 'CLASS="--class gnu-linux --class gnu --class os"',
		    match  => '^CLASS="--class gnu-linux --class gnu --class os',
		    notify => Exec["Re-generate grub configuration"],
		    path   => "/etc/grub.d/10_linux";
	    }
	}

	file {
	    "$do grub password configuration":
		content => template("common/grub-passwd.erb"),
		ensure  => $ensure,
		group   => hiera("gid_zero"),
		mode    => "0755",
		notify  => Exec["Re-generate grub configuration"],
		owner   => root,
		path    => "/etc/grub.d/01_CIS";
	}

	Package["grub-common"]
	    -> Package["grub2-common"]
	    -> File["Ensure /etc/default/grub present"]
    }

    Exec["Re-generate grub configuration"]
	-> File["Set proper permissions to /boot/grub/grub.cfg"]
}
