class trezor::github {
    $download = $trezor::vars::download
    $srvdir   = $trezor::vars::srvdir

    nodejs::define::module {
	[ "grunt-cli", "bower" ]:
	    app => false;
    }

    git::define::clone {
	"trezor-webwallet-data":
	    local_container => "/usr/share",
	    repository      => "https://github.com/trezor/webwallet-data",
	    update          => false;
    }

    nodejs::define::app {
	"trezor-webwallet":
	    appgit        => "https://github.com/trezor/webwallet",
	    dobower       => true,
	    startfork     => 1,
	    startwith     => "grunt",
	    startwithargs => "server",
	    require       =>
		[
		    Git::Define::Clone["trezor-webwallet-data"],
		    Nodejs::Define::Module["grunt-cli"],
		    Nodejs::Define::Module["bower"]
		];
    }
}
