--- group.rb	2015-05-21 22:54:42.000000000 +0200
+++ patched-group.rb	2016-01-25 12:27:41.098493297 +0100
@@ -131,6 +131,8 @@
 
     newparam(:ia_load_module, :required_features => :manages_aix_lam) do
       desc "The name of the I&A module to use to manage this user"
+
+      defaultto "compat"
     end
 
     newproperty(:attributes, :parent => Puppet::Property::KeyValue, :required_features => :manages_aix_lam) do
