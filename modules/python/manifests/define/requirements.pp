define python::define::requirements($requirements = $name,
				    $wd           = "/") {
    if (! defined(Class["python"])) {
	include python
    }

    exec {
	"Install $name requirements":
	    command     => "pip install -r $requirements",
	    cwd         => $wd,
	    onlyif      => "tests -s $requirements",
	    path        => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    refreshonly => true,
	    require     => Class["python"];
    }
}
