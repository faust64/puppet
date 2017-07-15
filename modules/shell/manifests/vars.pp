class shell::vars {
    $access_class = lookup("access_class")
    $charset      = lookup("locale_charset")
    $locale       = lookup("locale_LOCALE")
    $prompt_color = lookup("prompt_color")
    $prompt_style = lookup("prompt_style")
    $http_proxy   = lookup("squid_ip")
    $no_proxy_for = lookup("squid_exceptions")

    if ($prompt_style) {
	$style = $prompt_style
    } elsif ($virtual == "physical" or $virtual == "xen0" or $virtual == "openvzhn" or $is_virtual == false) {
	$style = "1"	# bold
    } else {
	$style = "0"
    }

    if ($prompt_color) {
	$color = $prompt_color
    } elsif ($access_class == "desktop") {
	$color = "33"
    } elsif ($access_class == "hosting") {
	$color = "35"	# purple
    } elsif ($access_class == "projet") {
	$color = "32"	# green
    } elsif ($access_class == "dev") {
	$color = "34"	# blue
    } else {
	$color = "31"	# red
    }

    case $operatingsystem {
	"OpenBSD": {
	    $puppet_var_dir = "/var/puppet"
	}
	default: {
	    $puppet_var_dir = "/var/lib/puppet"
	}
    }

    $prompt = "$style;$color"
}
