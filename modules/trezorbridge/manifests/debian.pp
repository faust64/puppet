class trezorbridge::debian {
    $deplist = [ "cmake", "libcurl4-gnutls-dev", "libprotobuf-dev", "pkg-config", "libusb-1.0-0", "libusb-1.0-0-dev", "libmicrohttpd-dev", "libboost-all-dev", "protobuf-compiler" ]

    common::define::package {
	$deplist:
    }
}
