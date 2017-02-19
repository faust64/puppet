class filetraq::vars {
    $backup_dir   = hiera("filetraq_backup_dir")
    $bin_dir      = hiera("filetraq_bin_dir")
    $conf_dir     = hiera("filetraq_conf_dir")
    $conf_include = hiera("filetraq_conf_include")
}
