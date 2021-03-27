class yum::config {
    exec {
	"Set YUM installonly_limit":
	    command => "sed -i -e 's|installonly_limit=.*|installonly_limit=2|' yum.conf",
	    cwd     => "/etc",
	    path    => "/usr/bin:/bin",
	    unless  => "grep installonly_limit=2 yum.conf";
    }

    file {
	"Prepare YUM for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/yum.repos.d",
	    require => Exec["Set YUM installonly_limit"];
    }
}
