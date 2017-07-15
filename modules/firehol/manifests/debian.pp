class firehol::debian {
    common::define::package {
	"firehol":
    }

    file {
	"Install Firehol defaults configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    notify  => Common::Define::Service["firehol"],
	    owner   => root,
	    path    => "/etc/default/firehol",
	    require => Common::Define::Package["firehol"],
	    source  => "puppet:///modules/firehol/defaults";
    }

    Common::Define::Package["firehol"]
	-> File["Prepare Firehol for further configuration"]
	-> Common::Define::Service["firehol"]
}
