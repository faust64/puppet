class nitrogen::vars {
    $home_dir      = hiera("generic_home_dir")
    $posx          = hiera("nitrogen_posx")
    $posy          = hiera("nitrogen_posy")
    $runtime_group = hiera("generic_group")
    $runtime_user  = hiera("generic_user")
    $sizex         = hiera("nitrogen_sizex")
    $sizey         = hiera("nitrogen_sizey")
}
