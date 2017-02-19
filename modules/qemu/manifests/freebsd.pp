class qemu::freebsd {
    common::define::package {
	[ "kqemu-kmod", "qemu" ]:
    }

    common::define::insertmodule { [ "kqemu", "aio" ]: }
}
