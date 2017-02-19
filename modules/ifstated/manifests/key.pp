class ifstated::key {
    $jumeau = $ifstated::vars::jumeau

    if ($jumeau) {
	Common::Define::Lined <<| tag == "fingerprint-root-$jumeau.$domain" |>>
	Ssh_authorized_key <<| tag == "$jumeau.$domain" |>>
    }
}
