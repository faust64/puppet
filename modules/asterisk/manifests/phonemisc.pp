class asterisk::phonemisc {
    $download = $asterisk::vars::download
    $repo     = $asterisk::vars::repo
    $srv_root = $asterisk::vars::webserver_root

    exec {
	"Download Aastra lang pack":
	    command     => "$download $repo/puppet/aastra_lang.tgz",
	    cwd         => "/root",
	    notify      => Exec["Extract Aastra lang pack"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s aastra_lang.tgz";
	"Extract Aastra lang pack":
	    command     => "tar -xf /root/aastra_lang.tgz",
	    cwd         => "$srv_root/aastra",
	    require     => File["Prepare Aastra configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Download Aastra firmwares":
	    command     => "$download $repo/puppet/aastra_fw.tgz",
	    cwd         => "/root",
	    notify      => Exec["Extract Aastra firmwares"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s aastra_fw.tgz";
	"Extract Aastra firmwares":
	    command     => "tar -xf /root/aastra_fw.tgz",
	    cwd         => "$srv_root/aastra",
	    require     => File["Prepare Aastra configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;

	"Download Cisco lang pack":
	    command     => "$download $repo/puppet/cisco_lang.tgz",
	    cwd         => "/root",
	    notify      => Exec["Extract Cisco lang pack"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s cisco_lang.tgz";
	"Extract Cisco lang pack":
	    command     => "tar -xf /root/cisco_lang.tgz",
	    cwd         => "$srv_root/cisco",
	    require     => File["Prepare Linksys configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Download Cisco firmwares":
	    command     => "$download $repo/puppet/cisco_fw.tgz",
	    cwd         => "/root",
	    notify      => Exec["Extract Cisco firmwares"],
	    path        => "/usr/bin:/bin",
	    unless      => "test -s cisco_fw.tgz";
	"Extract Cisco firmwares":
	    command     => "tar -xf /root/cisco_fw.tgz",
	    cwd         => "$srv_root/cisco",
	    require     => File["Prepare Linksys configuration directory"],
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
