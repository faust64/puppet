class trezor {
    include trezor::vars

    include common::tools::make
    include nodejs

    include trezor::github
    include trezor::webapp

    Class["common::tools::make"]
	-> Class["trezor::github"]
	-> Class["trezor::webapp"]
}
