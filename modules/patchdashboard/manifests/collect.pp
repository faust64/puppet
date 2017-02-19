class patchdashboard::collect {
    $upstream = $patchdashboard::vars::upstream

    Exec <<| tag == "patchdashboard-$upstream" |>>
}
