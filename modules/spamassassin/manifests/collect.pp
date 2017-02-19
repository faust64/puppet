class spamassassin::collect {
    Common::Define::Lined <<| tag == "spamassassin-sa-learn" |>>

    if ($spamassassin_clients) {
	each(split($spamassassin_clients, '\n')) |$remote| {
	    Common::Define::Lined <<| tag == "fingerprint-root-$remote" |>>
	}
    }
}
