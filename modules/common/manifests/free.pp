class common::free {
    $freeifless = 768
#   $memarray   = split($memorysize, '\.')
    $memarray   = split("$memoryfree_mb", '\.')
    $meminmb    = $memarray[0]

    exec {
	"Drop cache":
	    command => "sync ; echo 3 >/proc/sys/vm/drop_caches",
	    cwd     => "/",
	    onlyif  => "test 0$meminmb -le 0$freeifless",
	    path    => "/usr/bin:/bin";
    }
}
