<?php
if (function_exists("apc_cache_info") && function_exists("apc_sma_info"))
{
    $apcu_mode = function_exists("apcu_cache_info") && function_exists("apcu_sma_info");
    $time      = time();
    $mem       = apc_sma_info();
    $mem_size  = $mem['num_seg'] * $mem['seg_size'];
    $mem_avail = $mem['avail_mem'];
    $mem_used  = $mem_size - $mem_avail;
    $nseg      = $freeseg = $fragsize = $freetotal = 0;

    for ($i = $ptr = 0; $i < $mem['num_seg']; $ptr = 0, $i++)
    {
	foreach ($mem['block_lists'][$i] as $block)
	{
	    if ($block['offset'] != $ptr)
		++$nseg;
	    if ($block['size'] < (5 * 1024 * 1024))
		$fragsize += $block['size'];
	    $ptr        = $block['offset'] + $block['size'];
	    $freetotal += $block['size'];
	}
	$freeseg += count($mem['block_lists'][$i]);
    }
    if ($freeseg < 2)
    {
	$fragsize = 0;
	$freeseg  = 0;
    }

    if ($apcu_mode) {
	$cache               = apcu_cache_info();
	$user_hits           = $cache['nhits'];
	$user_misses         = $cache['nmisses'];
	$user_inserts        = $cache['ninserts'];
	$user_req_rate       = ($cache['nhits'] + $cache['nmisses']) / ($time - $cache['stime']);
	$user_hit_rate       = ($cache['nhits']) / ($time - $cache['stime']);
	$user_miss_rate      = ($cache['nmisses']) / ($time - $cache['stime']);
	$user_insert_rate    = ($cache['ninserts']) / ($time - $cache['stime']);
	$user_number_entries = $cache['nentries'];
	$user_purges         = $cache['nexpunges'];
	$user_mem_size       = $cache['mem_size'];
	$out                 = array(
		'mode: ' . 'apcu',
		'size: ' . $mem_size,
		'used: ' . $mem_used,
		'free: ' . ($mem_avail - $fragsize),
		'fragment_percentage: ' . sprintf("%.2f", ($fragsize/$mem_avail)*100),
		'fragmented: ' . sprintf("%.2f", $fragsize),
		'fragment_segments: ' . $freeseg,
		'user_size: ' . $user_mem_size,
		'user_hits: ' . sprintf("%.2f", ($user_hits + $user_misses) ? ($user_hits * 100 / ($user_hits + $user_misses)) : 0),
		'user_misses: ' . sprintf("%.2f", ($user_hits + $user_misses) ? ($user_misses * 100 / ($user_hits + $user_misses)) : 0),
		'user_request_rate: ' . sprintf("%.2f", $user_req_rate),
		'user_hit_rate: ' . sprintf("%.2f", $user_hit_rate),
		'user_miss_rate: ' . sprintf("%.2f", $user_miss_rate),
		'user_insert_rate: ' . sprintf("%.2f", $user_insert_rate),
		'user_entries: ' . $user_number_entries,
		'user_inserts: ' . $user_inserts,
		'user_purges: ' . $user_purges,
		'user_purge_rate: ' . sprintf("%.2f", $user_inserts ? (100 - ($user_number_entries / $user_inserts) * 100) : 0));
    } else {
	$cache_mode     = 'opmode';
	$cache          = @apc_cache_info($cache_mode);
	$hits           = $cache['num_hits'];
	$misses         = $cache['num_misses'];
	$inserts        = $cache['num_inserts'];
	$req_rate       = ($cache['num_hits'] + $cache['num_misses']) / ($time - $cache['start_time']);
	$hit_rate       = ($cache['num_hits']) / ($time - $cache['start_time']);
	$miss_rate      = ($cache['num_misses']) / ($time - $cache['start_time']);
	$insert_rate    = ($cache['num_inserts']) / ($time - $cache['start_time']);
	$number_entries = $cache['num_entries'];
	$purges         = $cache['expunges'];
	$out            = array(
		'size: ' . sprintf("%.2f", $mem_size),
		'used: ' . sprintf("%.2f", $mem_used),
		'free: ' . sprintf("%.2f", $mem_avail - $fragsize),
		'hits: ' . sprintf("%.2f", $hits * 100 / ($hits + $misses)),
		'misses: ' . sprintf("%.2f", $misses * 100 / ($hits + $misses)),
		'request_rate: ' . sprintf("%.2f", $req_rate),
		'hit_rate: ' . sprintf("%.2f", $hit_rate),
		'miss_rate: ' . sprintf("%.2f", $miss_rate),
		'insert_rate: ' . sprintf("%.2f", $insert_rate),
		'entries: ' . $number_entries,
		'inserts: ' . $inserts,
		'purges: ' . $purges,
		'purge_rate: ' . sprintf("%.2f", (100 - ($number_entries / $inserts) * 100)),
		'fragment_percentage: ' . sprintf("%.2f", ($fragsize / $mem_avail) * 100),
		'fragmented: ' . sprintf("%.2f", $fragsize),
		'fragment_segments: ' . $freeseg);
    }
}
else
{
    $out = array('APC-not-installed');
}
echo implode(' ', $out);
?>
