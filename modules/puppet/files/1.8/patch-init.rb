--- init.rb	2014-06-30 15:17:21.000000000 +0200
+++ patched-init.rb	2014-06-30 15:21:00.000000000 +0200
@@ -8,6 +8,8 @@
   end
 
   case Facter["operatingsystem"].value
+  when "OpenBSD"
+    @defpath = "/etc/rc.d"
   when "FreeBSD"
     @defpath = ["/etc/rc.d", "/usr/local/etc/rc.d"]
   when "HP-UX"
@@ -133,4 +135,3 @@
   end
 
 end
-
