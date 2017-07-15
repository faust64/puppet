class shell::ksh {
    $charset   = $shell::vars::charset
    $locale    = $shell::vars::locale
    $puppetvar = $shell::vars::puppet_var_dir
    $prompt    = $shell::vars::prompt

    file {
	"Main Ksh configuration":
	    content => template("shell/ksh.kshrc.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/ksh.kshrc";
	"Ksh root configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    source  => "puppet:///modules/shell/user.kshrc",
	    path    => "/root/.kshrc";
	"Ksh skel configuration":
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    source  => "puppet:///modules/shell/user.kshrc",
	    path    => "/etc/skel/.kshrc";
    }
}
