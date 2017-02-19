class subversion::rhel {
    common::define::package {
	"subversion":
    }

    if ($subversion::vars::web_front == true) {
	common::define::package {
	    "websvn":
	}
    }
}
