class moin::debian {
    common::define::package {
	"python-moinmoin":
    }

    Package["python-moinmoin"]
	-> File["Prepare MoinMoin for further configuration"]

    if ($moin::vars::apache_vers == "2.4") {
	File["Prepare MoinMoin for further configuration"]
	    -> File["Link MoinMoin wsgi"]
    } else {
	File["Prepare MoinMoin for further configuration"]
	    -> File["Link MoinMoin cgi"]
    }
}
