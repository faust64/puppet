class asterisk::rhel {
    $locale = $asterisk::vars::locale

    common::define::package {
	[
	    "asterisk",
	    "asterisk-addons",
	    "asterisk-voicemail"
	]:
    }

    if ($asterisk::vars::dahdi_chans and $virtual == "physical") {
	common::define::package {
	    [ "dahdi-tools", "asterisk-dahdi" ]:
	}

	Package["dahdi-tools"]
	    -> File["Prepare Dahdi for further configuration"]

	Package["asterisk-dahdi"]
	    -> File["Prepare Asterisk for further configuration"]
    }

    Package["asterisk-voicemail"]
	-> File["Prepare Asterisk for further configuration"]
}
