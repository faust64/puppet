class trezorbridge::github {
    $srvdir = $trezorbridge::vars::srvdir

    git::define::clone {
	"trezord":
	    local_container => "/usr/share",
	    notify          => Exec["Build trezord"],
	    repository      => "https://github.com/trezor/trezord",
	    submoduleinit   => true,
	    update          => false;
    }

    common::define::geturl {
	"config.proto":
	    nomv    => true,
	    notify  => Exec["Build config.proto"],
	    require => Git::Define::Clone["trezord"],
	    target  => "/usr/share/trezord/src/config/config.proto",
	    url     => "https://raw.githubusercontent.com/trezor/trezor-common/master/protob/config.proto",
	    wd      => "/usr/share/trezord/src/config";
    }

    exec {
	"Build config.proto":
	    command     => "protoc -I/usr/include -I. --cpp_out=. config.proto",
	    cwd         => "/usr/share/trezord/src/config",
	    notify      => Exec["Build trezord"],
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    refreshonly => true;
	"Build trezord":
	    command     => "./build.sh",
	    creates     => "/usr/share/trezord/build/trezord",
	    cwd         => "/usr/share/trezord",
	    path        => "/usr/local/sbin:/usr/bin:/sbin:/usr/local/bin:/usr/bin:/bin:/usr/share/trezord",
	    require     =>
		[
		    Git::Define::Clone["trezord"],
		    Exec["Fetch patched config.proto"]
		];
	"Install trezord":
	    command     => "install -D -m 0755 trezord /usr/bin/trezord",
	    creates     => "/usr/bin/trezord",
	    cwd         => "/usr/share/trezord/build",
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => Exec["Build trezord"];
	"Install trezord init script":
	    command     => "install -D -m 0755 trezord.init $srvdir/trezord",
	    creates     => "$srvdir/trezord",
	    cwd         => "/usr/share/trezord/release/linux",
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => Exec["Install trezord"];
	"Install trezord systemd configuration":
	    command     => "install -D -m 0644 trezord.service /lib/systemd/system/trezord.service",
	    creates     => "/lib/systemd/system/trezord.service",
	    cwd         => "/usr/share/trezord/release/linux",
	    onlyif      => "test -d /lib/systemd/system",
	    notify      => Exec["Load trezord systemd configuration"],
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => Exec["Install trezord"];
	"Load trezord systemd configuration":
	    command     => "systemctl daemon-reload",
	    cwd         => "/",
	    path        => "/usr/local/bin:/usr/bin:/bin",
	    require     => Exec["Install trezord systemd configuration"],
	    refreshonly => true;
    }
}
