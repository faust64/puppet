class nginx::debian {
    $runtime_user = $nginx::vars::runtime_user

    common::define::package {
	"nginx":
    }

    if ($runtime_user != "root") {
	exec {
	    "Set permissions to /var/lib/nginx/proxy":
		command     => "chown -R $runtime_user proxy",
		cwd         => "/var/lib/nginx",
		notify      => Service["nginx"],
		path        => "/usr/bin:/bin",
		refreshonly => true,
		subscribe   => Package["nginx"];
	}
    }

    if ($nginx::vars::with_cgi == true) {
	common::define::package {
	    "fcgiwrap":
	}

	Package["fcgiwrap"]
	    -> Package["nginx"]

	Service["fcgiwrap"]
	    -> Service["nginx"]
    }

    if ($lsbdistcodename == "buster") {
	if (! defined(Exec["Reload systemd configuration"])) {
	    include common::systemd
	}

	file_line {
	    "Fix nginx systemd configuration":
		line   => "After=network.target",
		match  => "^After=.*",
		notify => Exec["Reload systemd configuration"],
		path   => "/lib/systemd/system/nginx.service";
	}

	Common::Define::Package["nginx"]
	    -> File_line["Fix nginx systemd configuration"]
	    -> File["Drop nginx default enabled configuration"]
	    -> Common::Define::Service["nginx"]
    } else {
	Common::Define::Package["nginx"]
	    -> File["Drop nginx default enabled configuration"]
	    -> Common::Define::Service["nginx"]
    }
}
