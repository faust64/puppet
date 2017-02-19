#!/usr/bin/php
<?php
# Process oval data for RedHat/Sceintific Linux
# Notice: In OVAL for RH there is no distinguish between i686 and x86_64

include_once("../config/config.php");
include_once("../include/functions.php");
include_once("../include/mysql_connect.php");

$verbose = 0;

if (isset($argv[1]) && $argv[1] == "-v") $verbose = 1;

$sql = "SELECT value, value2 FROM settings WHERE name='RedHat CVEs URL' ORDER BY value ASC";
if (!$res = mysql_query($sql))
    die("DB: Select settings: ".mysql_error($link));
while ($row = mysql_fetch_row($res)) {
    if ($row[1] == 1) $oval_rh_file = $row[0];
    else continue;

    $oval_rh_file = trim($oval_rh_file);
    $oval = new DOMDocument();
    libxml_set_streams_context(get_context());
    $oval->load($oval_rh_file);
    $cves = array();
    $cves_desc = array();
    $el_l_generator = $oval->getElementsByTagName('generator');
    foreach ($el_l_generator as $el_generator) {
	$el_l_product = $el_generator->getElementsByTagName('product_name');
	if ($verbose) print $el_l_product->item(0)->nodeName . ": " . $el_l_product->item(0)->nodeValue .  " from $row[0]\n";
    }
    $el_l_defs = $oval->getElementsByTagName("definition");
    $sql = "LOCK TABLES pkgs WRITE, cves_os WRITE, cves WRITE, cve WRITE";
    if (!mysql_query($sql))
	die("DB: Unable to lock tables: ".mysql_error($link));
    foreach($el_l_defs as $el_def) {
	$def_id = $el_def->getAttribute('id');
	$def_version = $el_def->getAttribute('version');
	$def_class = $el_def->getAttribute('class');
	$title = rtrim($el_def->getElementsByTagName('title')->item(0)->nodeValue);
	$platform = $el_def->getElementsByTagName('platform')->item(0)->nodeValue;
	$ref_url = $el_def->getElementsByTagName('reference')->item(0)->getAttribute('ref_url');
	$el_severity = $el_def->getElementsByTagName('severity')->item(0);
	if (!empty($el_severity))
	    $severity = $el_severity->nodeValue;
	else $severity = "n/a";
	$cves = array();
	$el_l_cves = $el_def->getElementsByTagName('cve');
	foreach ($el_l_cves as $el_cve)
	    if ($el_cve->nodeValue != "")
		array_push($cves, $el_cve->nodeValue);
	$el_l_comments = $el_def->getElementsByTagName('criterion');
	$redhat_release = "";
	$package = "";
	foreach ($el_l_comments as $el_comment) {
	    $el_tmp = $el_comment->getAttribute('comment');
	    if (strpos($el_tmp, "is installed"))
		preg_match("/^Red Hat Enterprise Linux.* (\d+) is installed$/", $el_tmp, $redhat_release);
	    if (strpos($el_tmp, "is earlier than")) {
		list ($package, ,,, $version_raw) = explode(" ", $el_tmp);
		list ($version, $release) = explode("-", $version_raw);
	    }
	    if ($package != "" && $version != "") {
		$sql = "SELECT id FROM pkgs WHERE name='" . $package ."'";
		if (!$row = mysql_query($sql))
		    die("DB: Unable to get pkg id:".mysql_error($link));
		if (mysql_num_rows($row) >= 1) {
		    $item = mysql_fetch_row($row);
		    $pkg_id = $item[0];
		} else {
		    $sql = "INSERT INTO pkgs (name) VALUES ('" .$package. "')";
		    if (!mysql_query($sql))
			die("DB: Unable to add new pkg:".mysql_error($link));
		    $pkg_id = mysql_insert_id();
		}
		$rrelease = (isset($redhat_release[1])) ? '_'.$redhat_release[1] : '';
		$sql = "INSERT INTO cves (def_id, cves_os_id, arch_id, pkg_id, version, rel, operator, severity, title, reference) VALUES ('$def_id','rh$rrelease',0 ,'$pkg_id','$version','$release','<','$severity','$title','$ref_url') ON DUPLICATE KEY UPDATE id=last_insert_id(id), version='$version', rel='$release', severity='$severity', title='$title', reference='$ref_url'";
		if (!mysql_query($sql))
		    die("DB: Cannot insert cves data: ".mysql_error($link));
		$ins_id = mysql_insert_id();
		foreach ($cves as $cve) {
		    $sql2 = "INSERT IGNORE INTO cve (cves_id, cve_name) VALUES ($ins_id, '$cve')";
		    if (!mysql_query($sql2)) {
			    die("DB: Cannot insert cves data: ".mysql_error($link));
		    }
		}
		$package = "";
		$version = "";
		$release = "";
	    }
	}
    }
    $sql = "UNLOCK TABLES";
    if (!mysql_query($sql))
	die("DB: Unable to unlock tables: ".mysql_error($link));
}
?>
