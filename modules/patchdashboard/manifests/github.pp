class patchdashboard::github {
    common::define::geturl {
	"patchdashboard":
	    notify  => Exec["Extract patchdashboard"],
	    require => Common::Define::Package["unzip"],
	    target  => "/root/patchdashboard.zip",
	    url     => "https://github.com/faust64/patchdashboard/archive/peerio.zip",
	    wd      => "/root";
    }

    exec {
	"Extract patchdashboard":
	    command     => "unzip patchdashboard.zip && mv patchdashboard-peerio /usr/share/patchdashboard",
	    cwd         => "/root",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
	"Generate database init dump":
	    command     => "cat db_create.sql centos_data.sql >init.sql",
	    creates     => "/usr/share/patchdashboard/database/init.sql",
	    cwd         => "/usr/share/patchdashboard/database",
	    path        => "/usr/bin:/bin",
	    require     => Exec["Extract patchdashboard"];
    }
}
