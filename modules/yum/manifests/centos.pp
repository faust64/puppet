class yum::centos {
    $arrayvers = split($operatingsystemrelease, '\.')
    $shortvers = $arrayvers[0]

    file {
	"Install CentOS Base repository":
	    content => template("yum/centos-base.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/yum.repos.d/CentOS-Base.repo";
    }

    include yum::epel
}
