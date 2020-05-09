define katello::define::settings($org     = $katello::vars::katello_org,
				 $setting = $name,
				 $value   = false) {
    exec {
	"Configure $name":
	    command     => "hammer settings set --name '$setting' --value '$value' --organization '$org'",
	    environment => [ 'HOME=/root' ],
	    onlyif      => "hammer settings list --search '$setting' --organization '$org'",
	    path        => "/usr/bin:/bin",
	    require     => File["Install hammer cli configuration"],
	    unless      => "hammer settings list --search '$setting' --organization '$org' | grep ' | $value '";
    }
}
