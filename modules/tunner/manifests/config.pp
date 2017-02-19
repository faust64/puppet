class tunner::config {
    $download = $tunner::vars::download
    $driver   = $tunner::vars::driver
    $provider = $tunner::vars::provider

    exec {
	"Download required driver":
	    command => "$download $provider/$driver",
	    cwd     => "/lib/firmware",
	    path    => "/usr/bin:/bin",
	    unless  => "test -e $driver";
    }
}
