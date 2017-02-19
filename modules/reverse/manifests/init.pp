class reverse {
    include reverse::vars
    include apache
    include apache::utils
    include reverse::collect
    include reverse::config
    include reverse::scripts

    apache::define::vhost {
	"00-default":
	    vhostsource => "reverse";
    }
}
