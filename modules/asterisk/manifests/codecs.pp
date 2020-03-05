class asterisk::codecs {
    $arch    = $architecture ? {
			/64/    => "x64",
			default => "x32"
		    }
    $lib_dir = $asterisk::vars::lib_dir
    $repo    = $asterisk::vars::repo

    common::define::geturl {
	"asterisk codec iLBC":
	    notify  => Exec["Install Asterisk codec iLBC"],
	    require => File["Prepare Asterisk lib directory"],
	    target  => "/root/codec_ilbc-${asterisk_version}-$arch.so";
	    url     => "$repo/puppet/codec_ilbc-${asterisk_version}-$arch.so",
	    wd      => "/root";
    }

    exec {
	"Install Asterisk codec iLBC":
	    command     => "cp -p /root/codec_ilbc-${asterisk_version}-$arch.so codec_ilbc.so",
	    cwd         => "$lib_dir/modules",
	    notify      => Service[$asterisk::vars::service_name],
	    onlyif      => "ldd /root/codec_ilbc-${asterisk_version}-$arch.so",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
