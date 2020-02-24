class yum::rhel {
    $http_repo = lookup("puppet_http_repo")
    $arrayvers = split($operatingsystemrelease, '\.')
    $shortvers = $arrayvers[0]

    file {
	"Install RHEL Base repository":
	    content => template("yum/rhel-base.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/yum.repos.d/RedHat-Base.repo";
    }

    include yum::epel
}
