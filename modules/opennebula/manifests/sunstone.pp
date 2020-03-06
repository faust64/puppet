class opennebula::sunstone {
    $controller    = $opennebula::vars::controller
    $runtime_group = $opennebula::vars::runtime_group
    $runtime_user  = $opennebula::vars::runtime_user

    if (! defined(Class[nginx])) {
	include nginx
    }

    include common::libs::curlopenssl
    include common::libs::rubydev
    include common::tools::gcc
    include common::tools::make

    if ($nginx::vars::listen_ports['ssl'] == false) {
	$strict         = "max-age=63072000; includeSubdomains; preload"
    } else {
	$nginx_conf_dir = $nginx::vars::conf_dir
	$strict         = false

	file {
	    "Prepare Sunstone SSL directory":
		ensure  => directory,
		group   => $opennebula::vars::runtime_group,
		mode    => "0750",
		owner   => $opennebula::vars::runtime_user,
		path    => "/etc/one/ssl",
		require => Common::Define::Package["opennebula-sunstone"];
	}

	each(["crt", "key"]) |$ext| {
	    exec {
		"Copy Nginx certificate ($ext) to Sunstone":
		    command => "cp -p $nginx_conf_dir/ssl/server.$ext server.$ext",
		    cwd     => "/etc/one/ssl",
		    path    => "/usr/bin:/bin",
		    unless  => "cmp $nginx_conf_dir/ssl/server.$ext server.$ext",
		    require => File["Prepare Sunstone SSL directory"];
	    }

	    file {
		"Set proper permissions to Sunstone certificate ($ext)":
		    ensure  => present,
		    group   => $opennebula::vars::runtime_group,
		    mode    => "0640",
		    owner   => $opennebula::vars::runtime_user,
		    path    => "/etc/one/ssl/server.$ext",
		    require => Exec["Copy Nginx certificate ($ext) to Sunstone"];
	    }
	}

	common::define::lined {
	    "Set Sunstone VNCproxy SSL key":
		line    => ":vnc_proxy_key: /etc/one/ssl/server.key",
		match   => ":vnc_proxy_key:",
		notify  => Service["opennebula-sunstone"],
		path    => "/etc/one/sunstone-server.conf",
		require => File["Set proper permissions to Sunstone certificate (key)"];
	    "Set Sunstone VNCproxy SSL certificate":
		line    => ":vnc_proxy_cert: /etc/one/ssl/server.crt",
		match   => ":vnc_proxy_cert:",
		notify  => Service["opennebula-sunstone"],
		path    => "/etc/one/sunstone-server.conf",
		require => File["Set proper permissions to Sunstone certificate (crt)"];
	    "Enable Sunstone VNCproxy SSL support":
		line    => ":vnc_proxy_support_wss: yes",
		match   => ":vnc_proxy_support_wss:",
		notify  => Service["opennebula-sunstone"],
		path    => "/etc/one/sunstone-server.conf",
		require =>
		    [
			Common::Define::Lined["Set Sunstone VNCproxy SSL certificate"],
			Common::Define::Lined["Set Sunstone VNCproxy SSL key"]
		    ];
	    "Configure Sunstone listening on loopback":
		line    => ":host: 127.0.0.1",
		match   => ":host: ",
		notify  => Service["opennebula-sunstone"],
		path    => "/etc/one/sunstone-server.conf",
		require => Common::Define::Package["opennebula-sunstone"];
	}
    }

    common::define::package {
	"opennebula-sunstone":
    }

    common::define::lined {
	"Plug Sunstone to OpenNebula Controller":
	    line    => ":one_xmlrpc: http://$controller:2633/RPC2",
	    match   => ":one_xmlrpc: http://",
	    notify  => Service["opennebula-sunstone"],
	    path    => "/etc/one/sunstone-server.conf",
	    require => Common::Define::Package["opennebula-sunstone"];
    }

    exec {
	"Install opennebula gems":
	    command => "echo y | ./install_gems >geminstall.log 2>&1",
	    creates => "/usr/share/one/geminstall.log",
	    cwd     => "/usr/share/one",
	    path    => "/usr/share/one:/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin",
	    require =>
		[
		    Class[Common::Libs::Curlopenssl],
		    Class[Common::Libs::Rubydev],
		    Class[Common::Tools::Gcc],
		    Class[Common::Tools::Make],
		    Common::Define::Package["opennebula-sunstone"]
		];
	"Copy local ssh key to authorized keys":
	    command => "cat id_rsa.pub >authorized_keys",
	    cwd     => "/var/lib/one/.ssh",
	    path    => "/usr/bin:/bin",
	    require => Common::Define::Package["opennebula-sunstone"],
	    user    => $runtime_user,
	    unless  => "test -s authorized_keys";
    }

    nginx::define::vhost {
	$fqdn:
	    app_root        => "/usr/lib/one/sunstone/public",
	    app_port        => 9869,
	    require         => Common::Define::Service["opennebula-sunstone"],
	    stricttransport => $strict,
	    vhostsource     => "sunstone";
    }

    Common::Define::Package["opennebula-sunstone"]
	-> Common::Define::Package["opennebula-common"]
}
