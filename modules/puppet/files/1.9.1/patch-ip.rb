--- ip.rb	2013-07-11 01:00:14.000000000 +0200
+++ patched-ip.rb	2014-12-02 03:05:38.000000000 +0100
@@ -77,7 +77,8 @@
   def self.get_all_interface_output
     case Facter.value(:kernel)
     when 'Linux', 'OpenBSD', 'NetBSD', 'FreeBSD', 'Darwin', 'GNU/kFreeBSD', 'DragonFly'
-      output = Facter::Util::IP.exec_ifconfig(["-a","2>/dev/null"])
+	output = Facter::Util::IP.exec_ifconfig(["-a","2>/dev/null"])
+	output.gsub!(/^pass/, "")
     when 'SunOS'
       output = Facter::Util::IP.exec_ifconfig(["-a"])
     when 'HP-UX'
