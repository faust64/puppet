class patchdashboard::webapp {
    include apache
    include mysql

    $admin_pw = $patchdashboard::vars::admin_pw
    $company  = $patchdashboard::vars::company
    $db_name  = $patchdashboard::vars::db_name
    $db_pass  = $patchdashboard::vars::db_pass
    $db_user  = $patchdashboard::vars::db_user
    $rdomain  = $patchdashboard::vars::rdomain
    $salt     = $patchdashboard::vars::salt

    if ($domain != $rdomain) {
	$reverse = "patchdashboard.$rdomain"
	$aliases = [ $reverse ]
    } else {
	$reverse = false
	$aliases = false
    }

    mysql::define::create_database {
	$db_name:
	    dbpass   => $db_pass,
	    dbuser   => $db_user,
	    require  => Exec["Generate database init dump"],
	    withinit => "/usr/share/patchdashboard/database/init.sql";
    }

    exec {
	"Create Patchdashboard Admin user":
	    command => "echo \"INSERT INTO users (user_id,email,admin,display_name,password,active) VALUES ('admin','admin@localhost','1',NULL,'\"`/usr/share/patchdashboard/hash_pass.php $admin_pw $salt`\"','1')\" | mysql -u root $db_name",
	    cwd     => "/",
	    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require => Mysql::Define::Create_database[$db_name],
	    unless  => "echo \"SELECT id FROM users WHERE user_id = 'admin'\" | mysql -u root $db_name | grep '[0-9]'";
	"Create Company":
	    command => "echo \"INSERT INTO company (name,display_name,install_key) VALUES ('$company','$company','\"`< /dev/urandom tr -dc 'a-zA-Z0-9~!@#$%^&*_-' | head -c\${1:-32} | sha256sum | awk '{print \$1}'`\"')\" | mysql -u root $db_name",
	    cwd     => "/",
	    path    => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
	    require => Mysql::Define::Create_database[$db_name],
	    unless  => "echo SELECT name FROM company | mysql -u root $db_name | grep $company";
    }

    apache::define::vhost {
	"patchdashboard.$domain":
	    aliases        => $aliases,
	    allow_override => "All",
	    app_root       => "/usr/share/patchdashboard/html",
	    csp_name       => "patchdashboard",
	    require        =>
		[
		    Exec["Create Patchdashboard Admin user"],
		    Exec["Create Company"],
		    File["Install PatchDashboard database configuration"]
		],
	    with_reverse   => $reverse;
    }
}
