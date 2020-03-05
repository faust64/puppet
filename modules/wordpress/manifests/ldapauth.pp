class wordpress::ldapauth {
    $lib_dir  = $wordpress::vars::lib_dir
    $version  = $wordpress::vars::wpauthdir_version

    common::define::geturl {
	"wpDirAuth":
	    nomv    => true,
	    notify  => Exec["Extract wordpress wpDirAuth plugin"],
	    require => Package["wordpress"],
	    target  => "/root/wpdirauth.$version.zip",
	    url     => "https://downloads.wordpress.org/plugin/wpdirauth.$version.zip",
	    wd      => "/root";
    }

    exec {
	"Extract wordpress wpDirAuth plugin":
	    command     => "unzip /root/wpdirauth.$version.zip",
	    cwd         => "$lib_dir/wp-content/plugins",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
