class vebackup::key {
    $jumeau  = $vebackup::vars::jumeau
    $triplet = $vebackup::vars::triplet

    if ($jumeau) {
	Common::Define::Lined <<| tag == "fingerprint-root-$jumeau" |>>
	Common::Define::Lined <<| tag == "fingerprint-root-$jumeau.$domain" |>>
    }
    if ($triplet and $jumeau) {
	Common::Define::Lined <<| tag == "tcpwrapper-$triplet" |>>
	Ssh_authorized_key <<| tag == "$triplet" |>>
	Ssh_authorized_key <<| tag == "$triplet.$domain" |>>
    } elsif ($jumeau) {
	Common::Define::Lined <<| tag == "tcpwrapper-$jumeau" |>>
	Ssh_authorized_key <<| tag == "$jumeau" |>>
	Ssh_authorized_key <<| tag == "$jumeau.$domain" |>>
    }
}
