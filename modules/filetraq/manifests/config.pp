class filetraq::config {
    $conf_dir = $filetraq::vars::conf_dir

    file {
	"Install Filetraq main configuration":
	    content => template("filetraq/main.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/filetraq.conf",
	    require => File["Prepare Filetraq for further configuration"];
    }
}
