class racktables {
    include racktables::vars

    include common::libs::snmp
    include mysql
    include apache

    include racktables::collect
    include racktables::scripts
    include racktables::sourceforge
    include racktables::webapp

    Class["mysql"]
	-> Class["apache"]
	-> Class["racktables::sourceforge"]
	-> Class["racktables::webapp"]
	-> Class["racktables::collect"]
}
