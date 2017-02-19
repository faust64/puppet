#!/usr/bin/php
<?php
# Process cve data for FreeBSD ports tree

include_once("../config/config.php");
include_once("../include/functions.php");
include_once("../include/mysql_connect.php");

$verbose = 0;

if (isset($argv[1]) && $argv[1] == "-v") $verbose = 1;

$sql = "SELECT value, value2 FROM settings WHERE name='FreeBSD CVEs URL' ORDER BY value ASC";
if (!$res = mysql_query($sql))
    die("DB: Select settings: ".mysql_error($link));
while ($row = mysql_fetch_row($res)) {
    if ($row[1] == 1) $oval_fbsd_file = $row[0];
    else continue;

    $oval_fbsd_file = trim($oval_fbsd_file);
    $oval = new DOMDocument();
    libxml_set_streams_context(get_context());
    $oval->load($oval_fbsd_file);
    $cves = array();
    $cves_desc = array();
    $fb_defs = $oval->getElementsByTagName("vuln");
    $sql = "LOCK TABLES pkgs WRITE, cves_os WRITE, cves WRITE, cve WRITE";
    if (!mysql_query($sql))
	die("DB: Unable to lock tables: ".mysql_error($link));
    foreach($fb_defs as $vuln) {
	$def_id = $vuln->getAttribute('vid');
	$title = $vuln->getElementsByTagName('topic');
	$ref_url = $vuln->getElementsByTagName('url');
	$severity = "n/a";
	$cves = array();
	$fb_cves = $vuln->getElementsByTagName('cvename');
	foreach ($fb_cves as $fb_cve)
	    if ($fb_cve->nodeValue != "")
		array_push($cves, $fb_cve->nodeValue);
	$fb_comments = $vuln->getElementsByTagName('package');
	$package = "";
	foreach ($fb_comments as $fb_comment) {
	    $package = $fb_comment->getAttribute('name');
	    $version = $fb_comment->getAttribute('lt');
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
		$sql = "INSERT INTO cves (def_id, cves_os_id, arch_id, pkg_id, version, operator, severity, title, reference) VALUES ('$def_id','fb',0,'$pkg_id','$version','<','$severity','$title','$ref_url') ON DUPLICATE KEY UPDATE id=last_insert_id(id), version='$version', severity='$severity', title='$title', reference='$ref_url'";
		if (!mysql_query($sql))
		    die("DB: Cannot insert cves data: ".mysql_error($link));
		$ins_id = mysql_insert_id();
		foreach ($cves as $cve) {
		    $sql2 = "INSERT IGNORE INTO cve (cves_id, cve_name) VALUES ($ins_id, '$cve')";
		    if (!mysql_query($sql2))
			die("DB: Cannot insert cves data: ".mysql_error($link));
		}
		$package = "";
		$version = "";
	    }
	}
    }
    $sql = "UNLOCK TABLES";
    if (!mysql_query($sql))
	die("DB: Unable to unlock tables: ".mysql_error($link));
}
?>
