class postgres::profile {
    $lib_dir  = $postgres::vars::lib_dir
    $root_dir = $postgres::vars::root_dir

    file {
	"Install postgres user profile":
	    content => template("postgres/profile.erb"),
	    group   => $postgres::vars::runtime_group,
	    mode    => "0666",
	    owner   => root,
	    path    => "$root_dir/.profile",
	    require => File["Prepare postgresql main directory"],
    }
}
