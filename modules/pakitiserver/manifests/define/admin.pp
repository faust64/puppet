define pakitiserver::define::admin() {
    $create = "INSERT INTO users (user, dn) VALUES (\"$name\", \"$name\")"
    $check  = "SELECT dn FROM users WHERE user = \"$name\""

    exec {
	"Declare $name as pakiti admin":
	    command => "echo '$create' | mysql -Nu root pakiti2",
	    cwd     => "/",
	    path    => "/usr/bin:/bin",
	    require => Mysql::Define::Create_database["pakiti2"],
	    unless  => "echo '$check' | mysql -Nu root pakiti2 | grep '$name'";
    }
}
