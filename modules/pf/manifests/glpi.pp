class pf::glpi {
    $routeto = ' route-to ( $def_if $def_gw )'

    pf::define::glpi {
	"GLPI":
	    routeto => $routeto;
    }
}
