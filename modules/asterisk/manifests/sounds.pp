class asterisk::sounds {
    $repo = $asterisk::vars::repo

    asterisk::define::lang {
	$asterisk::vars::locale:
	    require =>
		[
		    Exec["Extract asterisk base sounds"],
		    Exec["Extract asterisk custom sounds"]
		];
    }

    common::define::geturl {
	"asterisk base sounds":
	    nomv   => true,
	    notify => Exec["Extract asterisk base sounds"],
	    target => "/root/asterisk-sounds-base.tar.gz",
	    url    => "$repo/puppet/asterisk-sounds-base.tar.gz",
	    wd     => "/root";
	"asterisk custom sounds":
	    nomv   => true,
	    notify => Exec["Extract asterisk custom sounds"],
	    target => "/root/asterisk-sounds-custom.tar.gz",
	    url    => "$repo/puppet/asterisk-sounds-custom.tar.gz",
	    wd     => "/root";
    }

    exec {
	"Extract asterisk base sounds":
	    command     => "tar -xf /root/asterisk-sounds-base.tar.gz",
	    cwd         => $asterisk::vars::var_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Asterisk var directory"];
	"Extract asterisk custom sounds":
	    command     => "tar -xf /root/asterisk-sounds-custom.tar.gz",
	    cwd         => $asterisk::vars::var_dir,
	    path        => "/usr/bin:/bin",
	    refreshonly => true,
	    require     => File["Prepare Asterisk var directory"];
    }
}
