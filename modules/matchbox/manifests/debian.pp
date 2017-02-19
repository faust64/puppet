class matchbox::debian {
    common::define::package {
	[ "matchbox-window-manager", "xwit" ]:
    }

    Class[Xorg]
	-> Package["xwit"]
	-> Package["matchbox-window-manager"]
	-> File["Install matchbox xinitrc"]
}
