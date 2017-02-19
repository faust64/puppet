define asterisk::define::lang {
    $all_langs = [ "en", "es", "fr" ]
    $var_dir   = $asterisk::vars::var_dir

    each($all_langs) |$lang| {
	if ($lang != $name) {
	    exec {
		"Move lang-$lang":
		    command => "mv $lang $lang.orig",
		    cwd     => "$var_dir/sounds",
		    onlyif  => "test -d $lang",
		    path    => "/usr/bin:/bin",
		    unless  => "test -d $lang.orig";
	    }

	    file {
		"Link $name as $lang":
		    ensure => link,
		    force  => true,
		    path   => "$var_dir/sounds/$lang",
		    target => "$var_dir/sounds/$name";
	    }
	}
    }
}
