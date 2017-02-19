class java::rhel {
    $vers = $java::vars::default_version

    common::define::package {
	"java-1.${vers}.0-openjdk":
    }
}
