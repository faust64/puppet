class selfoss::config {
    $db_backend = $selfoss::vars::db_backend
    $db_host    = $selfoss::vars::db_host
    $db_pass    = $selfoss::vars::db_pass
    $db_user    = $selfoss::vars::db_user
    $web_root   = $selfoss::vars::web_root

    file {
	"Install selfoss main configuration":
	    content => template("selfoss/config.erb"),
	    path    => "$web_root/selfoss/config.ini";
    }

    if ($selfoss::vars::db_backend == "mysql") {
	Mysql::Define::Create_database["selfoss"]
	    -> File["Install selfoss main configuration"]
    } else {
	Exec["Extract selfoss server root"]
	    -> File["Install selfoss main configuration"]
    }
}
