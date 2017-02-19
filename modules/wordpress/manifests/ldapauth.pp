class wordpress::ldapauth {
    $download = $wordpress::vars::download
    $lib_dir  = $wordpress::vars::lib_dir
    $version  = $wordpress::vars::wpauthdir_version

    exec {
	"Download wordpress wpDirAuth plugin":
	    command     => "$download https://downloads.wordpress.org/plugin/wpdirauth.$version.zip",
	    creates     => "/root/wpdirauth.$version.zip",
	    cwd         => "/root",
	    notify      => Exec["Extract wordpress wpDirAuth plugin"],
	    path        => "/usr/bin:/bin",
	    require     => Package["wordpress"];
	"Extract wordpress wpDirAuth plugin":
	    command     => "unzip /root/wpdirauth.$version.zip",
	    cwd         => "$lib_dir/wp-content/plugins",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
