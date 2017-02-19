define java::define::certificate_authority($java_dir = "java-${java::vars::default_version}-openjdk-$architecture",
					   $lib_dir  = "/usr/lib/jvm",
					   $password = "changeit",
					   $source   = "/etc/ssl/certs/ca.crt",
					   $store    = "cacerts") {
    exec {
	"Define Certificate $name into java trusted certificates":
	    command => "keytool -import -noprompt -trustcacerts -alias '$name' -file $source -keystore $store -storepass '$password'",
	    cwd     => "$lib_dir/$java_dir/jre/lib/security",
	    path    => "/usr/bin:/bin",
	    unless  => "keytool -list -v -keystore $store -alias '$name' -storepass '$password'";
    }
}
