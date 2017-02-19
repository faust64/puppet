--- ip.rb	2015-05-19 18:41:15.000000000 +0200
+++ patched-ip.rb	2016-01-25 12:25:01.354493296 +0100
@@ -82,6 +82,7 @@
     case Facter.value(:kernel)
     when 'Linux', 'OpenBSD', 'NetBSD', 'FreeBSD', 'Darwin', 'GNU/kFreeBSD', 'DragonFly', 'AIX'
       output = Facter::Util::IP.exec_ifconfig(["-a","2>/dev/null"])
+      output.gsub!(/^pass/, "")
     when 'SunOS'
       output = Facter::Util::IP.exec_ifconfig(["-a"])
     when 'HP-UX'
