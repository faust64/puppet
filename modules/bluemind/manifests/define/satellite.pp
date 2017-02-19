class bluemind::define::satellite {
    $routeto = hiera("postfix_routeto")

    File <<| tag == "postfix-$routeto" |>>
    Exec <<| tag == "postfix-$routeto" |>>
}
