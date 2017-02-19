class firehol::config {
    $ifs              = $firehol::vars::ifs
    $office_networks  = $firehol::vars::office_networks

    file {
	"Prepare Firehol for further configuration":
	    ensure  => directory,
	    group   => hiera("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/firehol";
	"Install Firehol main configuration":
	    content => template("firehol/firehol.erb"),
	    group   => hiera("gid_zero"),
	    mode    => "0644",
	    notify  => Common::Define::Service["firehol"],
	    owner   => root,
	    path    => "/etc/firehol/firehol.conf",
	    require => File["Prepare Firehol for further configuration"];
    }
}
