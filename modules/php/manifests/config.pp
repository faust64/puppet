class php::config {
    $conf_dir            = $php::vars::conf_dir
    $disabled_functions  = $php::vars::disabled_functions
    $errfilter           = $php::vars::errfilter
    $gc_probability      = $php::vars::gc_probability
    $hashbitsperchar     = $php::vars::hashbitsperchar
    $mail_ip             = $php::vars::mail_ip
    $mail_mx             = $php::vars::mail_mx
    $max_exectime        = $php::vars::max_exectime
    $mem_limit           = $php::vars::mem_limit
    $post_max            = $php::vars::post_max
    $serialize_precision = $php::vars::serialize_precision
    $tzdata              = $php::vars::tzdata
    $upload_max          = $php::vars::upload_max
    $zend_modules        = $php::vars::zend_modules

     file {
	"Prepare PHP for further configuration":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => $conf_dir;
	"Prepare PHP cli configuration directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/cli",
	    require => File["Prepare PHP for further configuration"];
	"Prepare PHP modules available directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/mods-available",
	    require => File["Prepare PHP for further configuration"];
	"Prepare PHP modules enabled directory":
	    ensure  => directory,
	    group   => lookup("gid_zero"),
	    mode    => "0755",
	    owner   => root,
	    path    => "$conf_dir/conf.d",
	    require => File["Prepare PHP for further configuration"];

	"Install PHP main configuration":
	    content => template("php/php.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "$conf_dir/cli/php.ini",
	    require => File["Prepare PHP cli configuration directory"];

# we've always been using priority 10 for both of these
# I suspect a packaging mishap since debian 8.1
# no traces in 7.X, nor warnings until yesterday night
	"Drop PHP 20-pdo.ini":
	    ensure  => absent,
	    force   => true,
	    path    => "$conf_dir/conf.d/20-pdo.ini",
	    require => File["Prepare PHP modules enabled directory"];
	"Drop PHP 20-mysqlnd.ini":
	    ensure  => absent,
	    force   => true,
	    path    => "$conf_dir/conf.d/20-mysqlnd.ini",
	    require => File["Prepare PHP modules enabled directory"];
    }
}
