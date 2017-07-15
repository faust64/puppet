class asterisk::agi {
    $data_dir = $asterisk::vars::data_dir
    $download = $asterisk::vars::download
    $repo     = $asterisk::vars::repo
    $version  = $asterisk::vars::version_maj

    exec {
	"Download asterisk agi scripts":
	    command     => "$download $repo/puppet/asterisk-agi-bin.tar.gz",
	    cwd         => "/root",
	    unless      => "tar -tf asterisk-agi-bin.tar.gz",
	    notify      => Exec["Extract asterisk agi scripts"],
	    path        => "/usr/bin:/bin";
	"Extract asterisk agi scripts":
	    command     => "tar -xf /root/asterisk-agi-bin.tar.gz",
	    cwd         => $data_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Asterisk data directory"];
    }

    file {
	"Install custom dialparties.agi":
	    content => template("asterisk/dialparties.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$data_dir/agi-bin/dialparties.agi",
	    require => Exec["Extract asterisk agi scripts"];
    }
}
