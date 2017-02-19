class thruk::webapp {
    if (! defined(Class[Apache])) {
	include apache
    }
    if (! defined(Class[Icinga::Logos])) {
	include icinga::logos
    }

    $base_dir  = $thruk::vars::base_dir
    $rdomain   = $thruk::vars::rdomain
    $tconf_dir = $thruk::vars::conf_dir
    $wconf_dir = $thruk::vars::apache_conf_dir

    file {
	"Drop thruk default web configuration":
	    ensure  => absent,
	    force   => true,
	    notify  => Service[$thruk::vars::apache_srvname],
	    path    => "$wconf_dir/conf.d/thruk.conf",
	    require => Package["thruk"];
	"Don't know / don't ask - VAR":
	    ensure  => directory,
	    group   => $thruk::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["thruk"],
	    owner   => $thruk::vars::runtime_user,
	    path    => "$base_dir/var",
	    require => Package["thruk"];
	"Don't know / don't ask - ETC":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/var/cache/thruk/ttc_33/etc",
	    require => Package["thruk"];
	"Don't know / don't ask - ETC/THRUK":
	    ensure  => link,
	    force   => true,
	    path    => "/var/cache/thruk/ttc_33/etc/thruk",
	    require => File["Don't know / don't ask - ETC"],
	    target  => $tconf_dir;
	"Don't know / don't ask - SSI":
	    ensure  => directory,
	    group   => $thruk::vars::runtime_group,
	    mode    => "0755",
	    notify  => Service["thruk"],
	    owner   => $thruk::vars::runtime_user,
	    path    => "$base_dir/ssi",
	    require => Package["thruk"];
	"Don't know / don't ask - SSI - link to etc":
	    ensure  => link,
	    force   => true,
	    path    => "$wconf_dir/ssi",
	    target  => "$base_dir/ssi";
	"Don't know / don't ask - cgi.cfg":
	    ensure  => link,
	    force   => true,
	    notify  => Service["thruk"],
	    path    => "$base_dir/cgi.cfg",
	    target  => "$tconf_dir/cgi.cfg";
    }

    apache::define::vhost {
	"thruk.$domain":
	    aliases      => [ "thruk.$rdomain" ],
	    app_root     => $base_dir,
	    deny_frames  => false,
	    vhostsource  => "thruk",
	    with_reverse => "thruk.$rdomain";
    }
}
