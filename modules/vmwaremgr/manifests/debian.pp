class vmwaremgr::debian {
    common::define::package {
	[ "e2fsprogs", "libxml2", "libxml-libxml-perl", "perl", "libxml-sax-perl", "libnet-ssleay-perl", "libarchive-zip-perl", "libhtml-parser-perl", "libdata-dump-perl", "libsoap-lite-perl", "liburi-perl", "liblwp-protocol-https-perl", "libclass-methodmaker-perl", "libcrypt-ssleay-perl", "perl-doc", "libssl-dev", "uuid-dev" ]:
    }

    file {
	"Let's fuck with vSphereCLI installer":
	    content => "ubuntu",
	    group   => lookup("gid_zero"),
	    mode    => "0644",
	    owner   => root,
	    path    => "/etc/vsphere-release";
    }

    File["Let's fuck with vSphereCLI installer"]
	-> Package["e2fsprogs"]
	-> Package["libxml2"]
	-> Package["libxml-libxml-perl"]
	-> Package["perl"]
	-> Package["libxml-sax-perl"]
	-> Package["libnet-ssleay-perl"]
	-> Package["libarchive-zip-perl"]
	-> Package["libhtml-parser-perl"]
	-> Package["libdata-dump-perl"]
	-> Package["libsoap-lite-perl"]
	-> Package["liburi-perl"]
	-> Package["liblwp-protocol-https-perl"]
	-> Package["libclass-methodmaker-perl"]
	-> Package["libcrypt-ssleay-perl"]
	-> Package["perl-doc"]
	-> Package["libssl-dev"]
	-> Package["uuid-dev"]
	-> Exec["Install vSphere CLI"]
}
