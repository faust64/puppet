define pf::define::glpi($debug   = false,
			$routeto = "") {
    $local_networks  = $pf::vars::local_networks
    $pf_custom_rules = $pf::vars::pf_custom_rules
    $timestamp       = generate('/bin/date', '+%Y/%d/%m')

    file {
	"Pf GLPI configuration":
	    content => template("pf/glpi.erb"),
	    group   => lookup("gid_zero"),
	    mode    => "0600",
	    notify  => Exec["Reload pf configuration"],
	    owner   => root,
	    path    => "/etc/pf.d/GLPI",
	    require => File["Pf Configuration directory"];
    }
}
