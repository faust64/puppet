class aide::setup {
    exec {
	"Init AIDE database":
	    command => "aideinit",
	    cwd     => $aide::vars::db_dir,
	    notify  => Exec["Install AIDE database"],
	    path    => "/usr/sbin:/sbin:/usr/bin:/bin",
	    timeout => 1600,
	    unless  => "test -s aide.db";
	"Install AIDE database":
	    command => "mv aide.db.new aide.db",
	    cwd     => $aide::vars::db_dir,
	    path    => "/usr/bin:/bin",
	    require => Exec["Init AIDE database"],
	    unless  => "test -s aide.db";
    }
}
