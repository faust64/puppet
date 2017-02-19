class camtrace::vars {
    $keyhash       = hiera("camtrace_keyhash")
    $keyid         = hiera("camtrace_keyid")
    $runtime_group = hiera("generic_group")
    $runtime_user  = hiera("generic_user")
    $sudo_conf_dir = hiera("sudo_conf_dir")
}
