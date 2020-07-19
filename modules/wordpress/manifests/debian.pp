class wordpress::debian {
    common::define::package {
	[ "wordpress" ]:
    }

    Package["unzip"]
	-> Package["wordpress"]
	-> Class["mysql"]
	-> Class["apache"]
	-> File["Install wordpress main configuration"]
	-> Mysql::Define::Create_database[$wordpress::vars::db_name]
	-> Apache::Define::Vhost[$wordpress::vars::srvname]
	-> Common::Define::Geturl["wp-cli"]
}
