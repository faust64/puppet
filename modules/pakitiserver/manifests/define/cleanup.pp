define pakitiserver::define::cleanup() {
    file {
	"Purge pakiti $name":
	    ensure  => absent,
	    force   => true,
	    path    => "/usr/share/pakiti/$name",
	    require => Exec["Generate Pakiti database initial import"];
    }
}
