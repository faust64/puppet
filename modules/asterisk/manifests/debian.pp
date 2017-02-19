class asterisk::debian {
    $locale = $asterisk::vars::locale

    common::define::package {
	[
	    "asterisk",
	    "asterisk-voicemail"
	]:
    }

    if ($asterisk::vars::dahdi_chans and $virtual == "physical") {
	common::define::package {
	    [
		"dahdi", "asterisk-dahdi",
		"dahdi-firmware-nonfree", "dahdi-linux"
	    ]:
	}

	Package["dahdi"]
	    -> File["Prepare Dahdi for further configuration"]
    }

    Package["asterisk"]
	-> Package["asterisk-voicemail"]
	-> File["Prepare Asterisk for further configuration"]
}
