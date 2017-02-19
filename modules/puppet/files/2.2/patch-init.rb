--- init.rb	2015-05-21 22:54:42.000000000 +0200
+++ patched-init.rb	2016-01-25 12:22:41.630493297 +0100
@@ -5,6 +5,8 @@
 
   def self.defpath
     case Facter.value(:operatingsystem)
+    when "OpenBSD"
+      "/etc/rc.d"
     when "FreeBSD", "DragonFly"
       ["/etc/rc.d", "/usr/local/etc/rc.d"]
     when "HP-UX"
