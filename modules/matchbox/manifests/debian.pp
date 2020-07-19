class matchbox::debian {
    common::define::package {
	[ "matchbox-window-manager", "xwit" ]:
    }

    Class["xorg"]
	-> Package["xwit"]
	-> Package["matchbox-window-manager"]
	-> File["Install matchbox xinitrc"]
}
