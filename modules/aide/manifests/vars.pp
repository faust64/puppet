class aide::vars {
    $conf_dir = hiera("aide_conf_dir")
    $contact  = hiera("aide_contact")
    $db_dir   = hiera("aide_database_dir")
}
