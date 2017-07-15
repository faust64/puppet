class yum::centos {
    $arrayvers = split($operatingsystemrelease, '\.')
    $download  = lookup("download_cmd")
    $shortvers = $arrayvers[0]

    file {
	"Install CentOS Base repository":
	    content => template("yum/centos-base.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/yum.repos.d/CentOS-Base.repo",
	    require => File["Prepare YUM for further configuration"];
    }

    exec {
	"Download EPEL repository key":
	    command => "$download https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-$shortvers",
	    cwd     => "/etc/pki/rpm-gpg",
	    path    => "/usr/bin:/bin",
	    unless  => "test -s RPM-GPG-KEY-EPEL-$shortvers";
    }

    yum::define::repo {
	"epel":
	    descr      => "Extra Packages - \$basearch",
	    failover   => "priority",
	    gpgkey     => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-$shortvers",
	    mirrorlist => "https://mirrors.fedoraproject.org/metalink?repo=epel-$shortvers&arch=\$basearch",
	    require    => Exec["Download EPEL repository key"];
    }
}
