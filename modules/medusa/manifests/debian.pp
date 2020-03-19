class medusa::debian {
    $data_dir      = $medusa::vars::data_dir
    $home_dir      = $medusa::vars::home_dir
    $runtime_group = $medusa::vars::runtime_group
    $runtime_user  = $medusa::vars::runtime_user

    if (! defined(Exec["Reload systemd configuration"])) {
	include common::systemd
    }
    if (! defined(Class["common::tools::netstat"])) {
	include common::tools::netstat
    }

    file {
	"Install medusa init script":
	    content => template("medusa/systemd.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    notify  =>
		[
		    Exec["Reload systemd configuration"],
		    Common::Define::Service["medusa"]
		],
	    owner   => root,
	    path    => "/etc/systemd/system/medusa.service",
	    require => Git::Define::Clone["medusa"];
    }

    File["Install medusa init script"]
	-> Exec["Reload systemd configuration"]
	-> Common::Define::Service["medusa"]
}
