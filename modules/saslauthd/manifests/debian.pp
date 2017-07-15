class saslauthd::debian {
    $conf_dir = $saslauthd::vars::conf_dir
    $run_dir  = $saslauthd::vars::run_dir

    common::define::package {
	"sasl2-bin":
    }

    file {
	"Install Saslauthd service defaults":
	    content => template("saslauthd/defaults.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Service["saslauthd"],
	    owner   => root,
	    path    => "/etc/default/saslauthd",
	    require => Package["sasl2-bin"];
    }

    Package["sasl2-bin"]
	-> File["Install Saslauthd main configuration"]
}
