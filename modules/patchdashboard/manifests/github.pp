class patchdashboard::github {
    git::define::clone {
	"patchdashboard":
	    branch          => "peerio",
	    local_container => "/usr/share",
	    repository      => "https://github.com/faust64/patchdashboard",
	    update          => false;
    }

    exec {
	"Generate database init dump":
	    command     => "cat db_create.sql centos_data.sql >init.sql",
	    creates     => "/usr/share/patchdashboard/database/init.sql",
	    cwd         => "/usr/share/patchdashboard/database",
	    path        => "/usr/bin:/bin",
	    require     => Git::Define::Clone["patchdashboard"];
    }
}
