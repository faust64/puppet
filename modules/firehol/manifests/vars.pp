class firehol::vars {
    $ifs              = hiera("firehol_interfaces")
    $office_networks  = hiera("office_networks")
}
