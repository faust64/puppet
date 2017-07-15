class shell::csh {
    $charset   = $shell::vars::charset
    $locale    = $shell::vars::locale
    $puppetvar = $shell::vars::puppet_var_dir
    $prompt    = $shell::vars::prompt

    file {
	"Main Csh configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    =>"/etc/csh.cshrc",
	    source  => "puppet:///modules/shell/csh.fallback.tcsh";
	"Main Tcsh configuration":
	    content => template("shell/csh.cshrc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/tcsh.tcshrc";
	"Tcsh root configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/root/.tcshrc",
	    source  => "puppet:///modules/shell/user.cshrc";
	"Tcsh skel configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/skel/.tcshrc",
	    source  => "puppet:///modules/shell/user.cshrc";
    }
}
