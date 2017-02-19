class asterisk::sounds {
    $download = $asterisk::vars::download
    $repo     = $asterisk::vars::repo

    asterisk::define::lang {
	$asterisk::vars::locale:
	    require =>
		[
		    Exec["Extract asterisk base sounds"],
		    Exec["Extract asterisk custom sounds"]
		];
    }

    exec {
	"Download asterisk base sounds":
	    command     => "$download $repo/puppet/asterisk-sounds-base.tar.gz",
	    cwd         => "/root",
	    unless      => "tar -tf asterisk-sounds-base.tar.gz",
	    notify      => Exec["Extract asterisk base sounds"],
	    path        => "/usr/bin:/bin";
	"Extract asterisk base sounds":
	    command     => "tar -xf /root/asterisk-sounds-base.tar.gz",
	    cwd         => $asterisk::vars::var_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Asterisk var directory"];
	"Download asterisk custom sounds":
	    command     => "$download $repo/puppet/asterisk-sounds-custom.tar.gz",
	    cwd         => "/root",
	    unless      => "tar -tf asterisk-sounds-custom.tar.gz",
	    notify      => Exec["Extract asterisk custom sounds"],
	    path        => "/usr/bin:/bin";
	"Extract asterisk custom sounds":
	    command     => "tar -xf /root/asterisk-sounds-custom.tar.gz",
	    cwd         => $asterisk::vars::var_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Asterisk var directory"];
    }
}
