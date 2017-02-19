<?php
# Copyright (c) 2008-2009, Grid PP, CERN and CESNET. All rights reserved.
#
# Redistribution and use in source and binary forms, with or
# without modification, are permitted provided that the following
# conditions are met:
#
#   o Redistributions of source code must retain the above
#     copyright notice, this list of conditions and the following
#     disclaimer.
#   o Redistributions in binary form must reproduce the above
#     copyright notice, this list of conditions and the following
#     disclaimer in the documentation and/or other materials
#     provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
# CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
# INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
# BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
# TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
# ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

# Compare packages version based on type of packages
# deb - compare version first, it they are equal then compare releases
# rpm - compre version and release together
# Returns 0 if $a and $b are equal
# Returns 1 if $a is greater than $b
# Returns -1 if $a is lower than $b
function vercmp($os, $ver_a, $rel_a, $ver_b, $rel_b) {
        switch ($os) {
                case "dpkg":
                        # We need to split vrsion and release
			if (strpos($ver_a, '-')) {
			        $vera = substr($ver_a, 0, strpos($ver_a,'-'));
			        $rela = substr($ver_a, strpos($ver_a,'-')+1);
			} else {
			        $vera = $ver_a;
				$rela = $rel_a;
			}

			if (strpos($ver_b, '-')) {
			        $verb = substr($ver_b, 0, strpos($ver_b,'-'));
			        $relb = substr($ver_b, strpos($ver_b,'-')+1);
			} else {
			        $verb = $ver_b;
				$relb = $rel_b;
			}

                        return dpkgvercmp($vera, $rela, $verb, $relb);
                        break;
                case "rpm":
                        $cmp_ret = rpmvercmp($ver_a, $ver_b);
                        if ($cmp_ret == 0)
                                return rpmvercmp($rel_a, $rel_b);
                        else return $cmp_ret;
			break;
		default:
			return rpmvercmp($ver_a . "-" . $rel_a, $ver_b . "-" . $rel_b);
        }
}

# Compare  RPM versions
# Returns 0 if $a and $b are equal
# Returns 1 if $a is greater than $b
# Returns -1 if $a is lower than $b
function rpm_split($a) {
   $arr = array();
   $i = 0;
   $j = 0;
   $l = strlen($a);
   while ($i < $l) {
       while ($i < $l && !ctype_alnum($a[$i]))
          $i++;
       if ($i == $l)
          break;

       $start = $i;
       if (ctype_digit($a[$i])) {
          while ($i < $l && ctype_digit($a[$i]))
             $i++;
       } else {
          while ($i < $l && ctype_alpha($a[$i]))
             $i++;
       }

       $arr[$j] = substr( $a, $start, $i - $start );
       $j++;
   }
   return $arr;
}

function rpmvercmp($a, $b) {
   if (strcmp($a, $b) == 0) return 0;

   $a_arr = rpm_split($a);
   $b_arr = rpm_split($b);

   $arr_len = count($a_arr);
   $barr_len = count($b_arr) - 1;

   for ($i = 0; $i < $arr_len; $i++) {
       if ($i > $barr_len)
          return 1;

       if (ctype_digit($a_arr[$i]) && ctype_alpha($b_arr[$i]))
          return 1;
       if (ctype_alpha($a_arr[$i]) && ctype_digit($b_arr[$i]))
          return -1;

       if ($a_arr[$i] > $b_arr[$i])
          return 1;
       if ($a_arr[$i] < $b_arr[$i])
          return -1;
   }

   if ($i <= $barr_len)
      return -1;

   return 0;
}

# Used by dpkgvercmp
function order($val) {
        if ($val == '') return 0;
        if ($val == '~') return -1;
        if (ctype_digit($val)) return 0;
        if (!ord($val)) return 0;
        if (ctype_alpha($val)) return ord($val);
        return  ord($val) + 256;
}

# Used by dpkgvercmp
function dpkgvercmp_in($a, $b) {
    $i = 0;
    $j = 0;
    $l = strlen($a);
    $k = strlen($b);

    while ($i < $l || $j < $k) {
	$first_diff = 0;
	while (($i < $l && !ctype_digit($a[$i])) || ($j < $k && !ctype_digit($b[$j]))) {
	    $vc = order($a[$i]);
	    $rc = order($b[$j]);
	    if ($vc != $rc)
		return $vc - $rc;
	    $i++;
	    $j++;
	}

	while (isset($a[$i]) && $a[$i] == '0')
	    $i++;
	while (isset($b[$j]) && $b[$j] == '0')
	    $j++;

	while (isset($a[$i]) && isset($a[$j])
	    && ctype_digit($a[$i]) && ctype_digit($b[$j])) {
	    if (!$first_diff)
		$first_diff = ord($a[$i]) - ord($b[$j]);
	    $i++;
	    $j++;
	}
	if (isset($a[$i]) && ctype_digit($a[$i]))
	    return 1;
	if (isset($b[$j]) && ctype_digit($b[$j]))
	    return -1;
	if ($first_diff)
	    return $first_diff;
    }
    return 0;
}

# Compare DPKG versions
# Returns 0 if $a and $b are equal
# Returns 1 if $a is greater than $b
# Returns -1 if $a is lower than $b

function dpkgvercmp($vera, $rela, $verb, $relb) {

        # Get epoch
        $epoch_a = substr($vera, 0, strpos($vera, ':'));
        $epoch_b = substr($verb, 0, strpos($verb, ':'));

        # If epoch is not there => 0
        if ($epoch_a == "") $epoch_a = "0";
        if ($epoch_b == "") $epoch_b = "0";

        if ($epoch_a > $epoch_b) return 1;
        if ($epoch_a < $epoch_b) return -1;

        # Compare versions
        $r = dpkgvercmp_in($vera, $verb);
        if ($r) {
                return $r;
        }

        # Compare release
        return dpkgvercmp_in($rela, $relb);
}

# Process package
# parameters:
# pkg - package name
# version - package version
# rel - package release
#
# Finds package id in the db, if doesn't exists then one is created.
# Check wheter provided package version and release are newer then stored one in db, if so then stores new value

function process_pkg($type, $pkg, $version, $rel, $is_sec, $arch_id, $os_group_id, $repo_id) {
	global $link;


        if ($pkg != "" and $version != "") {
                $sql = "SELECT id FROM pkgs WHERE name='" . $pkg ."'";
                if (!$row = mysql_query($sql)) {
                        syslog(LOG_ERR, "DB: Unable to get pkg id:".mysql_error($link));
                        return;
                }
                if (mysql_num_rows($row) < 1) {
                        # PKG is not present, so insert it
                        $sql = "INSERT INTO pkgs (name) VALUES ('" .$pkg. "')";
                        if (!mysql_query($sql)) {
                                syslog(LOG_ERR, "DB: Unable to add new pkg:".mysql_error($link));
                                return;
                        }
                        $pkg_id = mysql_insert_id($link);
                        $act_version = $version;
                        $act_rel = $rel;
                } else {
                        # PKG exits, so check if this is newer version
                        $item = mysql_fetch_row($row);
                        $pkg_id = $item[0];
                        $sql = "SELECT act_version, act_rel FROM act_version WHERE arch_id=$arch_id AND pkg_id=$pkg_id AND os_group_id=$os_group_id";
                        if (!$row = mysql_query($sql)) {
                                syslog(LOG_ERR, "DB: Unable to get act_version:".mysql_error($link));
				return;
                        }
			if (mysql_num_rows($row) == 0) {
				$act_version = $version;
                                $act_rel = $rel;
			} else {
        	                $item = mysql_fetch_row($row);
	                        $act_version = $item[0];
                	        $act_rel = $item[1];

				$cmp_ver = vercmp($type, $act_version, $act_rel, $version, $rel);

	                        if ($cmp_ver < 0) {
        	                        # This repository contains newer version
                	                $act_version = $version;
                        	        $act_rel = $rel;
	                        }
			}
                }

                # Store data into the db
                $sql = "INSERT INTO act_version (repo_id, arch_id, os_group_id, pkg_id, act_version, act_rel, is_sec)
			VALUES ($repo_id,$arch_id,$os_group_id,$pkg_id,'$act_version','$act_rel',$is_sec)
			ON DUPLICATE KEY UPDATE act_version='$act_version', act_rel='$act_rel', is_sec=$is_sec, repo_id=$repo_id, os_group_id=$os_group_id";
                if (!$row = mysql_query($sql)) {
                        syslog(LOG_ERR, "DB: Unable to add new act_version:".mysql_error($link));
                	return;
		};

                $pkg = "";
                $version = "";
                $rel = "";
        }
}


##########################################
# Process debian package file 'packages'

function process_dpkg_pkgs($file, $is_sec, $arch_id, $os_group_id, $repo_id) {
	$fp = fopen($file,'r');
	if ($fp) {
		while ($line = fgets($fp)) {
			if (substr($line , 0, 8) == 'Package:') {
				$pkg = trim(substr($line, 9));
				continue;
			} else if (substr($line, 0, 13) == 'Architecture:') {
				$arch = trim(substr($line, 14));
				continue;
			} else if (substr($line, 0, 8) == 'Version:') {
				$version = trim(substr($line, 9));
			}
			else continue;

			process_pkg("dpkg", $pkg, $version, "", $is_sec, $arch_id, $os_group_id, $repo_id);
		}
		fclose($fp);
	} else {
		print "Cannot open $file\n";
	}
}

# Process SLC/RedHat/SuSE primary.xml file

function process_rpm_pkgs($filename, $is_sec, $arch_id, $arch_name, $os_group_id, $repo_id) {

  # Check if we have XMLReader
  if (method_exists('XMLReader', 'open')) {

		include("process_rpm_pkgs_xmlreader.php");

  } else {
	# We are probably in PHP 4, where XMLReader is not available, so use DOM

		include("process_rpm_pkgs_domxml.php");

  }
}

# Check wheter reported package is kernel package and then checks if it running kernel */
# is_unsused_kernel_pkg( running kernel, package name, package version, package release )

function is_unused_kernel_pkg($kernel, $pkg_name, $pkg_version, $pkg_release) {
	global $kernel_pkg_names;

	$pkg_name = trim($pkg_name);
	$pkg_version = trim($pkg_version);
	$pkg_release = trim($pkg_release);
	$kernel = trim($kernel);

	if (array_search($pkg_name, $kernel_pkg_names) !== false) {

		# Remove epoch
		if ($pos = strpos($pkg_version, ":")) {
			$pkg_version = substr($pkg_version, $pos+1);
		}

#		syslog(LOG_ERR,"Running kernel $kernel");
		# Due to some other strings clued to the kernel version, we are looking for substring
		#if (strpos($kernel, "$pkg_version-$pkg_release") === false) {
		if (strcmp($kernel, $pkg_version . "-" . $pkg_release) != 0) {
	#		syslog(LOG_ERR, "Ommiting kernel $pkg_name $pkg_version-$pkg_release");
			return true;
		}
		else {
	#		syslog(LOG_ERR, "Accepting kernel $pkg_name $pkg_version-$pkg_release");
			return false;
		}
	}
	return false;
}

function get_link() {
       global $secret;
       $filename = basename($_SERVER['SCRIPT_NAME']);
       $query = $_SERVER['QUERY_STRING'];

       $new_url = "https://" . $_SERVER['HTTP_HOST'] . "/link/$filename?$query&ts=" . time();

       $hashcode = sha1($new_url . $secret);

       return "$new_url&auth=$hashcode";

}
function check_link($auth) {
       global $secret;
       $url_tmp = "https://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];
       $i = strpos($url_tmp, '&auth=');
       $url = substr($url_tmp, 0, $i);
       if ($auth == sha1($url . $secret)) {
               if (empty($_GET['ts'])) {
                       return false;
	       }

               //  link is valid only for defined lifetime
	       global $anonymous_link_lifetime;
               if ((time() - $_GET['ts']) > $anonymous_link_lifetime) {
                       return false;
		}

               return true;
       } else {
               return false;
       }
}

function start_time() {
	$mtime = microtime();
	$mtime = explode(" ", $mtime);
	return $mtime[1] + $mtime[0];
}
function end_time($start_time) {
	$mtime = microtime();
	$mtime = explode(" ", $mtime);
	$mtime = $mtime[1] + $mtime[0];
	return ($mtime - $start_time);
}

function get_logged_user() {
	$user = array_key_exists('REMOTE_USER', $_SERVER) ? $_SERVER['REMOTE_USER'] : "";
	if ($user == "") {
		$user = array_key_exists('SSL_CLIENT_S_DN', $_SERVER) ? $_SERVER['SSL_CLIENT_S_DN'] : "";
	}
	return trim($user);
}

function check_authz_all() {
       global $admin_dns;
        $user = get_logged_user();

        if ($user == "") {
                return -1;
        }
        if (in_array($user, $admin_dns)) {
                return 1;
        }
        $sql = "SELECT 1 FROM users WHERE users.dn='$user'";
        if (!$res = mysql_query($sql)) {
                return -1;
        }
        if (mysql_num_rows($res) > 0) {
                return 1;
        }
}

function check_authz($domain_id) {
	global $admin_dns;
	$user = get_logged_user();

	if ($user == "") {
		return -1;
	}
	if (in_array($user, $admin_dns)) {
		return 1;
	}
	$sql = "SELECT 1 FROM user_domain, users WHERE users.dn='$user' AND
		user_domain.user_id=users.id AND user_domain.domain_id=$domain_id";
	if (!$res = mysql_query($sql)) {
		return -1;
	}
	if (mysql_num_rows($res) > 0) {
		return 1;
	}
}

function check_authz_site($site_id) {
	global $admin_dns;
	$user = get_logged_user();

	if ($user == "") {
		return -1;
	}
	if (in_array($user, $admin_dns)) {
		return 1;
	}
	$sql = "SELECT 1 FROM user_site, users WHERE users.dn='$user' AND
		user_site.user_id=users.id AND user_site.site_id=$site_id";
	if (!$res = mysql_query($sql)) {
		return -1;
	}
	if (mysql_num_rows($res) > 0) {
		return 1;
	}
}

function check_admin_authz() {
        global $admin_dns;
	$user = get_logged_user();

       	if ($user == "") {
		return -1;
	}
	if (in_array($user, $admin_dns)) {
                return 1;
        } else return -1;
}

function get_authz_domain_ids() {
	global $admin_dns;
	$user = get_logged_user();

	if ($user == "") {
		return -1;
	}

	if (in_array($user, $admin_dns)) {
		return 1;
	}
	$sql = "SELECT domain_id FROM user_domain, users WHERE users.dn='$user' AND
		user_domain.user_id=users.id";
	if (!$res = mysql_query($sql)) {
		return -1;
	}
	$ret = "";
	$num = mysql_num_rows($res);
	while ($row = mysql_fetch_row($res)) {
		$ret .= "domain.id=$row[0]";
		if ($num != 1) $ret .= " OR ";
		$num--;
	}
	return $ret;
}

function get_authz_site_ids() {
	global $admin_dns;
	$user = get_logged_user();

	if ($user == "") {
		return -1;
	}

	if (in_array($user, $admin_dns)) {
		return 1;
	}
	$sql = "SELECT site_id FROM user_site, users WHERE users.dn='$user' AND
		user_site.user_id=users.id";
	if (!$res = mysql_query($sql)) {
		return -1;
	}
	$ret = "";
	$num = mysql_num_rows($res);
	while ($row = mysql_fetch_row($res)) {
		$ret .= "site.id=$row[0]";
		if ($num != 1) $ret .= " OR ";
		$num--;
	}
	return $ret;
}

function get_authz_site_names() {
	global $admin_dns;
	$user = get_logged_user();

	if ($user == "") {
		return -1;
	}

	if (in_array($user, $admin_dns)) {
		return 1;
	}
	$sql = "SELECT site.name FROM user_site, users, site WHERE users.dn='$user' AND
		user_site.user_id=users.id AND site.id=user_site.site_id";
	if (!$res = mysql_query($sql)) {
		return -1;
	}
	$ret = "";
	$num = mysql_num_rows($res);
	while ($row = mysql_fetch_row($res)) {
		$ret .= "site_name='$row[0]'";
		if ($num != 1) $ret .= " OR ";
		$num--;
	}
	return $ret;
}

# Returns path to the ungzipped file
function ungzip($gzfile) {
	if ($gzfile) {
		$gzfilename = tempnam("/tmp","pakiti_gz");
		$tmpgzfile = fopen($gzfilename, "w");
		if ($tmpgzfile) {
			if (version_compare(PHP_VERSION, '5.0.0', '>=')) {
		                $fp = @fopen($gzfile, 'r', false, get_context());
		        } else {
		                $fp = @fopen($gzfile, 'r', false);
		        }

			if ($fp === false) {
				print "ERROR: cannot open '$gzfile'\n";
				return "";
			}

			while ($content = fread($fp, 10000)) {
				fwrite($tmpgzfile, $content);
			}
		}
		fclose($tmpgzfile);
		$tmpgzfile = gzopen($gzfilename, "r");
		$filename = tempnam("/tmp","pakiti");
		$file = fopen($filename, "w");
		if ($file) {
			while ($content = gzread($tmpgzfile, 10000)) {
				fwrite($file, $content);
			}
		}
		gzclose($tmpgzfile);
		unlink($gzfilename);
		fclose($file);
		fclose($fp);

		return $filename;
	} else return "";
}

# Returns path to the unbzipped file
function unbzip($bzfile) {
	if ($bzfile) {
		$bzfilename = tempnam("/tmp","pakiti_bz");
		$tmpbzfile = fopen($bzfilename, "w");
		if ($tmpbzfile) {
			if (version_compare(PHP_VERSION, '5.0.0', '>=')) {
		                $fp = @fopen($bzfile, 'r', false, get_context());
		        } else {
		                $fp = @fopen($bzfile, 'r', false);
		        }

			if ($fp === false) {
				print "ERROR: cannot open '$bzfile'\n";
				return "";
			}

			while ($content = fread($fp, 10000)) {
				fwrite($tmpbzfile, $content);
			}
		}
		fclose($tmpbzfile);
		$tmpbzfile = bzopen($bzfilename, "r");
		$filename = tempnam("/tmp","pakiti");
		$file = fopen($filename, "w");
		if ($file) {
		       while ($content = bzread($tmpbzfile, 10000)) {
				fwrite($file, $content);
			}
		}
		bzclose($tmpbzfile);
		unlink($bzfilename);
		fclose($file);
		fclose($fp);

		return $filename;
	} else return "";
}

function get_context() {
	global $web_proxy;
	global $verbose;

	if (isset($web_proxy) && !empty($web_proxy) ) {
	       $opts = array(
		       	'http' => array(
			       	'proxy' => "$web_proxy",
				'request_fulluri' => true
				)
		       );
	       if ($verbose) print "Using web proxy: ".$web_proxy."\n";
	} else {
	       $opts = array(
		       'http' => array(
			       'method'=>"GET",
		       )
		       );
	}
       return stream_context_create($opts);
}

function exit_with_unlock() {
	global $link;
	mysql_query("UNLOCK TABLES");
	mysql_close($link);
	exit;
}

function vanish_unused_kernels($items, $kernel) {
        global $kernel_pkg_names;

	$kernels = array();
	// Find all packages which represents kernels
	foreach($kernel_pkg_names as $ckernel) {
	        if ($key = array_search($ckernel, $items[1]) !== false) {
			array_push($kernels, $key);
		}
	}

	$found = 0;
	foreach($kernels as $key) {
		$pkg_version = $items[2][$key];
		$pkg_release = $items[3][$key];
		# Remove epoch
                if ($pos = strpos($pkg_version, ":")) {
                        $pkg_version = substr($pkg_version, $pos+1);
                }

		if (strcmp($kernel, "$pkg_version-$pkg_release") == 0) {
                       $found = 1;
                }
	}
	return $found;
}

?>
