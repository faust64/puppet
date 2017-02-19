class apt::filetraq {
    filetraq::define::trac {
	"apt":
	     pathlist =>
		[
		    "/etc/apt/sources.list",
		    "/etc/apt/sources.list.d/*"
		];
    }
}
