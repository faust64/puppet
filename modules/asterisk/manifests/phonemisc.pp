class asterisk::phonemisc {
    $repo     = $asterisk::vars::repo
    $srv_root = $asterisk::vars::webserver_root

    common::define::geturl {
	"Aastra lang pack":
	    nomv   => true,
	    notify => Exec["Extract Aastra lang pack"],
	    target => "/root/aastra_lang.tgz",
	    url    => "$repo/puppet/aastra_lang.tgz",
	    wd     => "/root";
	"Aastra firmwares":
	    nomv   => true,
	    notify => Exec["Extract Aastra firmwares"],
	    target => "/root/aastra_fw.tgz",
	    url    => "$repo/puppet/aastra_fw.tgz",
	    wd     => "/root";
	"Cisco lang pack":
	    nomv   => true,
	    notify => Exec["Extract Cisco lang pack"],
	    target => "/root/cisco_lang.tgz",
	    url    => "$repo/puppet/cisco_lang.tgz",
	    wd     => "/root";
	"Cisco firmwares":
	    nomv   => true,
	    notify => Exec["Extract Cisco firmwares"],
	    target => "/root/cisco_fw.tgz",
	    url    => "$repo/puppet/cisco_fw.tgz",
	    wd     => "/root";
    }

    exec {
	"Extract Aastra lang pack":
	    command     => "tar -xf /root/aastra_lang.tgz",
	    cwd         => "$srv_root/aastra",
	    require     => File["Prepare Aastra configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Extract Aastra firmwares":
	    command     => "tar -xf /root/aastra_fw.tgz",
	    cwd         => "$srv_root/aastra",
	    require     => File["Prepare Aastra configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Extract Cisco lang pack":
	    command     => "tar -xf /root/cisco_lang.tgz",
	    cwd         => "$srv_root/cisco",
	    require     => File["Prepare Linksys configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Extract Cisco firmwares":
	    command     => "tar -xf /root/cisco_fw.tgz",
	    cwd         => "$srv_root/cisco",
	    require     => File["Prepare Linksys configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
