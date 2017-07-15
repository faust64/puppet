class vim::config {
    file {
	"Prepare vim for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "/etc/vim";
	"Install vim default local configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/vim/vimrc.local",
	    require => File["Prepare vim for further configuration"],
	    source  => "puppet:///modules/vim/vimrc.local";
	"Install vim default minimal configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/vimrc",
	    source  => "puppet:///modules/vim/vimrc.local";
	"Install vim default skel configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/skel/.vimrc",
	    source  => "puppet:///modules/vim/vimrc.local";
	"Install vim root configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.vimrc",
	    source  => "puppet:///modules/vim/vimrc.local";
    }
}
