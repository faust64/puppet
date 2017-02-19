--- ip.rb	2014-07-06 23:22:41.000000000 +0200
+++ patched-ip.rb	2014-07-06 23:18:50.000000000 +0200
@@ -74,7 +74,7 @@
   def self.get_all_interface_output
     case Facter.value(:kernel)
     when 'Linux', 'OpenBSD', 'NetBSD', 'FreeBSD', 'Darwin', 'GNU/kFreeBSD', 'DragonFly'
-      output = %x{/sbin/ifconfig -a}
+      output = %x{/sbin/ifconfig -a | grep -v '^pass '}
     when 'SunOS'
       output = %x{/usr/sbin/ifconfig -a}
     when 'HP-UX'
