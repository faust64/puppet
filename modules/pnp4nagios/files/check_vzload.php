<?php
# Plugin: check_vzload

$opt[1] = "--vertical-label Load -l0 --title \"CPU Load for $hostname / $servicedesc\" ";
$def[1] = '';
for ($x = 1; isset($DS[$x]); $x = $x + 1)
{
    $def[1] .= rrd::def("var$x", $RRDFILE[1], $DS[$x], "AVERAGE");
}

if ($WARN[1] != "") $def[1] .= "HRULE:$WARN[1]#FFFF00 ";
if ($CRIT[1] != "") $def[1] .= "HRULE:$CRIT[1]#FF0000 ";

for ($x = $x - 1; $x > 0; $x = $x - 1)
{
    $c = $x <= 16 ? "0".dechex($x) : dechex($x);
    $d = 256 - $x < 16 ? "0".dechex(256 - $x) : dechex(256 - $x);
    $e = dechex(42 + $x);
    $def[1] .= rrd::area("var$x", "#${d}{$e}{$c}", $NAME[$x]);
    $def[1] .= rrd::gprint("var$x", "AVERAGE", "%6.2lf");
}
?>
