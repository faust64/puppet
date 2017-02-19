class patchdashboard::github {
    $download = $patchdashboard::vars::download

    exec {
	"Download patchdashboard":
	    command     => "$download https://github.com/faust64/patchdashboard/archive/peerio.zip && mv peerio.zip patchdashboard.zip",
	    creates     => "/usr/share/patchdashboard",
	    cwd         => "/root",
	    notify      => Exec["Extract patchdashboard"],
	    path        => "/usr/bin:/bin",
	    require     => Common::Define::Package["unzip"];
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
