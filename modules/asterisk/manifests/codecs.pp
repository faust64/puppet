class asterisk::codecs {
    $arch     = $architecture ? {
			/64/    => "x64",
			default => "x32"
		    }
    $download = $asterisk::vars::download
    $lib_dir  = $asterisk::vars::lib_dir
    $repo     = $asterisk::vars::repo

    exec {
	"Download asterisk codec iLBC":
	    command     => "$download $repo/puppet/codec_ilbc-${asterisk_version}-$arch.so",
	    cwd         => "/root",
	    notify      => Exec["Install Asterisk codec iLBC"],
	    path        => "/usr/bin:/bin",
	    require     => File["Prepare Asterisk lib directory"],
	    unless      => "ldd codec_ilbc-${asterisk_version}-$arch.so";
	"Install Asterisk codec iLBC":
	    command     => "cp -p /root/codec_ilbc-${asterisk_version}-$arch.so codec_ilbc.so",
	    cwd         => "$lib_dir/modules",
	    notify      => Service[$asterisk::vars::service_name],
	    onlyif      => "ldd /root/codec_ilbc-${asterisk_version}-$arch.so",
	    path        => "/usr/bin:/bin",
	    refreshonly => true;
    }
}
