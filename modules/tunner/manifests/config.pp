class tunner::config {
    $driver   = $tunner::vars::driver
    $provider = $tunner::vars::provider

    common::define::geturl {
	"$driver":
	    nomv   => true,
	    target => "/lib/firmware/$driver"
	    url    => "$provider/$driver",
	    wd     => "/lib/firmware",
    }
}
