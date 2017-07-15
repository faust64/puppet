define filetraq::define::trac($pathlist = false) {
    $include_dir = lookup("filetraq_conf_include")

    if ($pathlist and ! defined(File["Filetraq $name configuration"])) {
	file {
	    "Filetraq $name configuration":
		content => template("filetraq/trac.erb"),
		group   => lookup("gid_zero"),
		mode    => "0644",
		owner   => root,
		path    => "$include_dir/$name.conf",
		require => File["Prepare Filetraq for further configuration"];
	}
    }
}
