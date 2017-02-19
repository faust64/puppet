class shell::vars {
    $access_class = hiera("access_class")
    $charset      = hiera("locale_charset")
    $locale       = hiera("locale_LOCALE")
    $prompt_color = hiera("prompt_color")
    $prompt_style = hiera("prompt_style")
    $http_proxy   = hiera("squid_ip")
    $no_proxy_for = hiera("squid_exceptions")

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
