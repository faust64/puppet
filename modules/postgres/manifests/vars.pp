class postgres::vars {
    $dbdir         = hiera("postgres_data_dir")
    $dbreldir      = hiera("postgres_data_reldir")
    $lib_dir       = hiera("postgres_lib_dir")
    $root_dir      = hiera("postgres_root_dir")
    $runtime_group = hiera("postgres_runtime_group")
    $runtime_user  = hiera("postgres_runtime_user")
}
