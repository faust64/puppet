#!/usr/bin/php
<?php

include_once("../config/config.php");
include_once("../include/functions.php");
include_once("../include/mysql_connect.php");

$verbose = 0;
$options = getopt ("fv");

foreach (array_keys($options) as $opt) switch ($opt) {
  case 'f':
    $force_update = true;
    break;

  case 'v':
    $verbose = true;
	break;
}

##########################################
# Set the timestamp of the update procedure, this timestamp is used for selecting repositories, that contains any new packages

$sql = "SELECT 1 FROM settings WHERE name='repositories_update_timestamp'";
if (!$row = mysql_query($sql)) {
	die("DB: Unable to get repositories update timestamp: ".mysql_error($link));
}
if (mysql_num_rows($row) > 0) {
  $sql = "UPDATE settings SET value=CURRENT_TIMESTAMP WHERE name='repositories_update_timestamp'";
  if (!mysql_query($sql)) {
	die("DB: Unable to set repositories update timestamp: ".mysql_error($link));
  }
} else {
  $sql = "INSERT INTO settings (name, value) VALUES ('repositories_update_timestamp',CURRENT_TIMESTAMP)";
  if (!mysql_query($sql)) {
	  die("DB: Unable to set set repositories update timestamp: ".mysql_error($link));
  }
}

###########################################
# Get files from repositories

$sql = " SELECT r.name, r.url, r.is_sec, r.arch_id, r.type, r.id, r.os_group_id, r.file_checksum, a.arch
	FROM repositories r, arch a
	WHERE r.arch_id=a.id AND enabled=1 ORDER BY name";

if (!$res = mysql_query($sql)) {
	die("DB: Unable to get repository:".mysql_error($link));
}

if ($verbose) print "Processing ...\n";
if ($verbose and $force_update) print "(Force mode)\n";
if ($verbose and $web_proxy) print "Using web proxy: ".$web_proxy."\n";

while ($row = mysql_fetch_row($res)) {

	# Process packages
	if ($verbose) print "$row[0] .";

	$filename = $row[1];
	$is_sec = $row[2];
	$arch_id = $row[3];
	$repo_type = $row[4];
	$repo_id = $row[5];
	$os_group_id = $row[6];
	$checksum = $row[7];
	$arch_name = $row[8];

	# Check if the repository changed (context in fopen is available from PHP 5.0.0)
	if (version_compare(PHP_VERSION, '5.0.0', '>=')) {
		$fp = @fopen($filename, 'r', false, get_context());
	} else {
		$fp = @fopen($filename, 'r', false);
	}
	if ($fp === false) {
		# Problem getting file, so skip it
		if ($verbose) print " ERROR - cannot get data from $filename\n";
		$sql = "UPDATE repositories SET last_access_ok=0 WHERE id=$repo_id";
		if (!mysql_query($sql)) {
			die ("DB: Unable to set last access flag for repository: ".mysql_error($link));
		}
		continue;
	}
	$contents = stream_get_contents($fp);
	$file_checksum = md5($contents);
	$do_force_update = (isset($force_update) && $force_update);
	fclose($fp);

	if ($checksum == $file_checksum and ! $do_force_update) {
		if ($verbose) print " - no change, skipping\n";
		continue;
	}

	if (substr($filename, -3, 3) == ".gz") {
		$filename = ungzip($filename);
	} else if (substr($filename, -4, 4) == ".bz2") {
		$filename = unbzip($filename);
	}

	if ($verbose) print ".";
	$sql = "LOCK TABLES act_version WRITE, pkgs WRITE, repositories WRITE" ;
	if (!mysql_query($sql)) {
		die ("DB: Unable to lock tables: ".mysql_error($link));
	}
	if ($filename) {
		switch ($repo_type) {
			case "dpkg":
				process_dpkg_pkgs($filename, $is_sec, $arch_id, $os_group_id, $repo_id);
				break;
			case "rpm":
				process_rpm_pkgs($filename, $is_sec, $arch_id, $arch_name, $os_group_id, $repo_id);
				break;
		}
		@unlink($filename);
	}
	$sql = "UPDATE repositories SET last_access_ok=1, timestamp=CURRENT_TIMESTAMP WHERE id=$repo_id";
	if (!mysql_query($sql)) {
		die("DB: Unable to set last access flag for repository: ".mysql_error($link));
	}

	$sql = "UPDATE repositories SET file_checksum='$file_checksum' WHERE id=$repo_id";
	# Only update the checksum if we've got this far
	if (!mysql_query($sql)) {
		die ("DB: Unable to update repository checksum: ".mysql_error($link));
	}

	$sql = "UNLOCK TABLES" ;
	if (!mysql_query($sql)) {
		die("DB: Unable to unlock tables: ".mysql_error($link));
	}
	if ($verbose) print ". OK\n";
}

mysql_close($link);
?>
