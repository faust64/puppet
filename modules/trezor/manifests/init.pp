class trezor {
    include trezor::vars

    include common::tools::make
    include nodejs

    include trezor::github
    include trezor::webapp

    Class[Common::Tools::Make]
	-> Class[Trezor::Github]
	-> Class[Trezor::Webapp]
}
