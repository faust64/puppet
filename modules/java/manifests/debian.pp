class java::debian {
    $vers = $java::vars::default_version

    common::define::package {
	"openjdk-${vers}-jre-headless":
    }
}
