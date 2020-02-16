class racktables {
    include racktables::vars

    include common::libs::snmp
    include mysql
    include apache

    include racktables::collect
    include racktables::scripts
    include racktables::sourceforge
    include racktables::webapp

    Class[Mysql]
	-> Class[Apache]
	-> Class[Racktables::Sourceforge]
	-> Class[Racktables::Webapp]
	-> Class[Racktables::Collect]
}
