--- init.rb	2013-07-12 02:15:45.000000000 +0200
+++ patched-init.rb	2014-12-02 03:12:46.000000000 +0100
@@ -5,6 +5,8 @@
 
   def self.defpath
     case Facter.value(:operatingsystem)
+    when "OpenBSD"
+      "/etc/rc.d"
     when "FreeBSD", "DragonFly"
       ["/etc/rc.d", "/usr/local/etc/rc.d"]
     when "HP-UX"
