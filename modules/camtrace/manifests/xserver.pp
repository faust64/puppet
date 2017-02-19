class camtrace::xserver {
    class {
	'openbox':
	    dm              => "slim",
	    with_feh        => false;
	'x11vnc':
	    service_depends => "slim",
	    service_runs_as => $camtrace::vars::runtime_user;
    }

    file {
	"Install camtrace user xinitrc":
	    group   => $camtrace::vars::runtime_group,
	    mode    => "0755",
	    owner   => $camtrace::vars::runtime_user,
	    path    => "/usr/local/camtrace/.xinitrc",
	    require => Class[Xorg],
	    source  => "puppet:///modules/camtrace/xinitrc";
	"Install lxpanel fr toolbar":
	    group   => $camtrace::vars::runtime_group,
	    mode    => "0644",
	    owner   => $camtrace::vars::runtime_user,
	    path    => "/usr/local/camtrace/.config/lxpanel/default/panels/locale/bottom-fr_FR",
	    require => Class[Xorg],
	    source  => "puppet:///modules/camtrace/lxpanel-toolbar-fr";
	"Install lxpanel en toolbar":
	    group   => $camtrace::vars::runtime_group,
	    mode    => "0644",
	    owner   => $camtrace::vars::runtime_user,
	    path    => "/usr/local/camtrace/.config/lxpanel/default/panels/locale/bottom-en_US",
	    require => Class[Xorg],
	    source  => "puppet:///modules/camtrace/lxpanel-toolbar-us";
    }
}
