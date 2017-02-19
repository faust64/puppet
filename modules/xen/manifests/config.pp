class xen::config {
    $apt_proxy          = $xen::vars::apt_proxy
    $default_vg         = $xen::vars::default_vg
    $dns_ip             = $xen::vars::dns_ip
    $jumeau             = $xen::vars::jumeau
    $mail_hub           = $xen::vars::mail_hub
    $repo               = $xen::vars::repo
    $vz_default_bridge  = $xen::vars::vz_default_bridge
    $vz_default_gateway = $xen::vars::vz_default_gateway
    $vz_default_netmask = $xen::vars::vz_default_netmask

    file {
	"Prepare Xen for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/xen";
	"Prepare Xen VE configuration directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/xen/conf",
	    require => File["Prepare Xen for further configuration"];
	"Prepare Xen VE autoboot directory":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/xen/auto",
	    require => File["Prepare Xen for further configuration"];
	"Install xl configuration":
	    group  => hiera("gid_zero"),
	    mode   => "0600",
	    owner  => root,
	    path   => "/etc/xen/xl.conf",
	    source => "puppet:///modules/xen/xl.conf";
    }

    if (! defined(File["Install custom OpenVZ configuration"])) {
	file {
	    "Install custom Xen configuration":
		content => template("openvz/virtual.erb"),
		group   => hiera("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "/etc/virtual.conf";
	}
    }

    exec {
	"Move xen kernel prior to default one":
	    command     => "mv 20_linux_xen 09_linux_xen",
	    cwd         => "/etc/grub.d",
	    notify      => Exec["Re-generate grub configuration"],
	    onlyif      => "test -s 20_linux_xen",
	    path        => "/usr/bin:/bin";
    }

#    if ($operatingsystem == "Ubuntu") {
#	common::define::lined {
#	    "Ensure xen kernel boot isn't password-protected":
#		line    => 'CLASS="--class gnu-linux --class gnu --class os --class xen --unrestricted"',
#		match   => '^CLASS="--class gnu-linux --class gnu --class os --class xen',
#		notify  => Exec["Re-generate grub configuration"],
#		path    => "/etc/grub.d/09_linux_xen",
#		require => Exec["Move xen kernel prior to default one"];
#	}
#    }
}
