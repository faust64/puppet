class bluemind::define::satellite {
    $routeto = lookup("postfix_routeto")

    File <<| tag == "postfix-$routeto" |>>
    Exec <<| tag == "postfix-$routeto" |>>
}
