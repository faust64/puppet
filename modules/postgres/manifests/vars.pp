class postgres::vars {
    $dbdir         = lookup("postgres_data_dir")
    $dbreldir      = lookup("postgres_data_reldir")
    $lib_dir       = lookup("postgres_lib_dir")
    $root_dir      = lookup("postgres_root_dir")
    $runtime_group = lookup("postgres_runtime_group")
    $runtime_user  = lookup("postgres_runtime_user")
}
