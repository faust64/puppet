HTMLSTYLE overlib
HEIGHT 865
WIDTH 800
HTMLOUTPUTFILE index.html
IMAGEOUTPUTFILE weathermap.png
FONTDEFINE 42 /var/www/wmap/fonts/VerilySerifMono.otf 10
FONTDEFINE 43 /var/www/wmap/fonts/VerilySerifMono.otf 6

SCALE  0   5 140  32 255 <5%
SCALE  5  10 140   0 255 <10%
SCALE 10  15  32  64 255 <15%
SCALE 15  20  32 128 255 <20%
SCALE 20  25   0 168 255 <25%
SCALE 25  30   0 192 255 <30%
SCALE 30  35   0 204 192 <35%
SCALE 35  40   0 216 128 <40%
SCALE 40  45   0 228  64 <45%
SCALE 45  50   0 240   0 <50%
SCALE 50  55  80 240   0 <55%
SCALE 55  60 112 240   0 <60%
SCALE 60  65 144 240   0 <65%
SCALE 65  70 176 240   0 <70%
SCALE 70  75 208 240   0 <75%
SCALE 75  80 240 240   0 <80%
SCALE 80  85 255 224   0 <85%
SCALE 85  90 255 192   0 <90%
SCALE 90  95 255 160   0 <95%
SCALE 95 100 255   0   0  mucho
KEYPOS DEFAULT 155 780 Resources Usage
KEYSTYLE DEFAULT horizontal

NODE fibrefree
    POSITION 300 40
    LABEL Free
    LABELFONT 42
    ICON 80 80 /var/www/wmap/images/cloud.png

NODE fibreorange
    POSITION 500 40
    LABEL Orange
    LABELFONT 42
    ICON 80 80 /var/www/wmap/images/cloud.png

NODE fw1
    POSITION 500 200
    LABEL Zeus
    LABELFONT 42
    LABELOFFSET E
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/fw.png

NODE fw2
    POSITION 300 200
    LABEL Io
    LABELFONT 42
    LABELOFFSET E
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/fw.png

NODE sw1
    POSITION 550 300
    LABEL Eros
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw2
    POSITION 250 300
    LABEL Gaia
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

#NODE sw3
#    POSITION 400 250
#    LABEL Amphilogiai
#    LABELFONT 42
#    LABELOFFSET N
#    LABELOUTLINECOLOR 255 255 255
#    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw3
    POSITION 700 300
    LABEL Nikea
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw4
    POSITION 100 300
    LABEL Ponos
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE cam1
    POSITION 70 410
    LABEL cam1
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/camera.png

NODE cam2
    POSITION 130 410
    LABEL cam2
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/camera.png

NODE vs1
    POSITION 290 410
    LABEL Nemesis
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs2
    POSITION 530 410
    LABEL Thanatos
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs3
    LABEL Momos
    POSITION 370 410
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs4
    POSITION 450 410
    LABEL Moros
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs5
    POSITION 200 410
    LABEL Oneiroi
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs6
    POSITION 610 410
    LABEL Oizis
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE store1
    POSITION 700 410
    LABEL Hesperus
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph1
    POSITION 740 520
    LABEL Helios
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph1disk1
    LABEL ceph-15
    POSITION ceph1 0 60
    TARGET gauge:/var/www/mrtg/helios/helios.disk.49.rrd:ds0:ds1
    MAXVALUE 1.9T

NODE ceph1disk2
    LABEL ceph-16
    POSITION ceph1 0 80
    TARGET gauge:/var/www/mrtg/helios/helios.disk.50.rrd:ds0:ds1
    MAXVALUE 920G

NODE ceph1disk3
    LABEL ceph-17
    POSITION ceph1 0 100
    TARGET gauge:/var/www/mrtg/helios/helios.disk.48.rrd:ds0:ds1
    MAXVALUE 920G

NODE ceph2
    POSITION 643 520
    LABEL Selene
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph2disk1
    LABEL ceph-12
    POSITION ceph2 0 60
    TARGET gauge:/var/www/mrtg/selene/selene.disk.49.rrd:ds0:ds1
    MAXVALUE 1.9T

NODE ceph2disk2
    LABEL ceph-13
    POSITION ceph2 0 80
    TARGET gauge:/var/www/mrtg/selene/selene.disk.50.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ceph2disk3
    LABEL ceph-14
    POSITION ceph2 0 100
    TARGET gauge:/var/www/mrtg/selene/selene.disk.48.rrd:ds0:ds1
    MAXVALUE 920G

NODE ceph3
    POSITION 254 520
    LABEL Eos
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph3disk1
    LABEL ceph-4
    POSITION ceph3 0 60
    TARGET gauge:/var/www/mrtg/eos/eos.disk.50.rrd:ds0:ds1
    MAXVALUE 470G

NODE ceph3disk2
    LABEL ceph-5
    POSITION ceph3 0 80
    TARGET gauge:/var/www/mrtg/eos/eos.disk.49.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph3disk3
    LABEL ceph-6
    POSITION ceph3 0 100
    TARGET gauge:/var/www/mrtg/eos/eos.disk.51.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph3disk4
    LABEL ceph-7
    POSITION ceph3 0 120
    TARGET gauge:/var/www/mrtg/eos/eos.disk.48.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph4
    POSITION 351 520
    LABEL Hemara
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph4disk1
    LABEL ceph-8
    POSITION ceph4 0 60
    TARGET gauge:/var/www/mrtg/hemara/hemara.disk.48.rrd:ds0:ds1
    MAXVALUE 460G

NODE ceph4disk2
    LABEL ceph-9
    POSITION ceph4 0 80
    TARGET gauge:/var/www/mrtg/hemara/hemara.disk.51.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph4disk3
    LABEL ceph-10
    POSITION ceph4 0 100
    TARGET gauge:/var/www/mrtg/hemara/hemara.disk.50.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph4disk4
    LABEL ceph-11
    POSITION ceph4 0 120
    TARGET gauge:/var/www/mrtg/hemara/hemara.disk.49.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ceph5
    POSITION 448 520
    LABEL Nyx
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph5disk1
    LABEL ceph-0
    POSITION ceph5 0 60
    TARGET gauge:/var/www/mrtg/nyx/nyx.disk.49.rrd:ds0:ds1
    MAXVALUE 470G

NODE ceph5disk2
    LABEL ceph-1
    POSITION ceph5 0 80
    TARGET gauge:/var/www/mrtg/nyx/nyx.disk.48.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph5disk3
    LABEL ceph-2
    POSITION ceph5 0 100
    TARGET gauge:/var/www/mrtg/nyx/nyx.disk.50.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph5disk4
    LABEL ceph-3
    POSITION ceph5 0 120
    TARGET gauge:/var/www/mrtg/nyx/nyx.disk.51.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph6
    POSITION 545 520
    LABEL Erebe
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph6disk1
    LABEL ceph-18
    POSITION ceph6 0 60
    TARGET gauge:/var/www/mrtg/erebe/erebe.disk.49.rrd:ds0:ds1
    MAXVALUE 442G

NODE ceph6disk2
    LABEL ceph-19
    POSITION ceph6 0 80
    TARGET gauge:/var/www/mrtg/erebe/erebe.disk.48.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ceph6disk3
    LABEL ceph-20
    POSITION ceph6 0 100
    TARGET gauge:/var/www/mrtg/erebe/erebe.disk.51.rrd:ds0:ds1
    MAXVALUE 1.9T

NODE ceph6disk4
    LABEL ceph-21
    POSITION ceph6 0 120
    TARGET gauge:/var/www/mrtg/erebe/erebe.disk.50.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ceph7
    POSITION 157 520
    LABEL Aether
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph7disk1
    LABEL ceph-22
    POSITION ceph7 0 60
    TARGET gauge:/var/www/mrtg/aether/aether.disk.49.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph7disk2
    LABEL ceph-23
    POSITION ceph7 0 80
    TARGET gauge:/var/www/mrtg/aether/aether.disk.50.rrd:ds0:ds1
    MAXVALUE 1.9T

NODE ceph7disk3
    LABEL ceph-24
    POSITION ceph7 0 100
    TARGET gauge:/var/www/mrtg/aether/aether.disk.48.rrd:ds0:ds1
    MAXVALUE 442G

NODE ceph8
    POSITION 60 520
    LABEL Ouranos
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

NODE ceph8disk1
    LABEL ceph-25
    POSITION ceph8 0 60
    TARGET gauge:/var/www/mrtg/ouranos/10.42.242.24.disk.48.rrd:ds0:ds1
    MAXVALUE 442G

NODE ceph8disk2
    LABEL ceph-26
    POSITION ceph8 0 80
    TARGET gauge:/var/www/mrtg/ouranos/10.42.242.24.disk.49.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ceph8disk3
    LABEL ceph-27
    POSITION ceph8 0 100
    TARGET gauge:/var/www/mrtg/ouranos/10.42.242.24.disk.51.rrd:ds0:ds1
    MAXVALUE 3.7T

NODE ceph8disk4
    LABEL ceph-28
    POSITION ceph8 0 120
    TARGET gauge:/var/www/mrtg/ouranos/10.42.242.24.disk.52.rrd:ds0:ds1
    MAXVALUE 2.8T

NODE ap1
    POSITION 700 710
    LABEL Asteros
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/ap.png

NODE ap2
    POSITION 100 710
    LABEL Cerberus
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/ap.png

NODE guestwifi
    POSITION 400 685
    LABEL Guests VLAN
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 30 30 /var/www/wmap/images/cloud.png

NODE userswifi
    POSITION 400 710
    LABEL WiFi VLAN
    LABELFONT 42
    LABELOFFSET N
    LABELOUTLINECOLOR 255 255 255
    ICON 30 30 /var/www/wmap/images/cloud.png

NODE faustwifi
    POSITION 400 735
    LABEL Faust VLAN
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 30 30 /var/www/wmap/images/cloud.png

LINK fw1orange
    ARROWSTYLE 1 1
    BANDWIDTH 103M 106M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw1:N fibreorange
    TARGET /var/www/mrtg/zeus/10.42.242.5_12.rrd:ds0:ds1
    WIDTH 3

LINK fw2orange
    ARROWSTYLE 1 1
    BANDWIDTH 103M 106M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw2:N fibreorange
    TARGET /var/www/mrtg/io/10.42.242.3_12.rrd:ds0:ds1
    WIDTH 3

LINK fw1free
    ARROWSTYLE 1 1
    BANDWIDTH 106M 111M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw1:N fibrefree
    TARGET /var/www/mrtg/zeus/10.42.242.5_10.rrd:ds0:ds1
    WIDTH 3

LINK fw2free
    ARROWSTYLE 1 1
    BANDWIDTH 106M 111M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw2:N fibrefree
    TARGET /var/www/mrtg/io/10.42.242.3_10.rrd:ds0:ds1
    WIDTH 3

LINK fw1lan
    ARROWSTYLE 1 1
    BANDWIDTH 3000M
    BWFONT 43
    BWLABELPOS 40 20
    NODES fw1:S90 sw1:N
    TARGET /var/www/mrtg/zeus/10.42.242.5_7.rrd:ds0:ds1
    WIDTH 2

LINK fw2lan
    ARROWSTYLE 1 1
    BANDWIDTH 3000M
    BWFONT 43
    BWLABELPOS 40 20
    NODES fw2:SW sw2:NE85
    TARGET /var/www/mrtg/io/10.42.242.3_7.rrd:ds0:ds1
    WIDTH 2

LINK tosw3
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    NODES sw1:E sw3:W
    TARGET /var/www/mrtg/sw1/10.42.242.13_40.rrd:ds0:ds1
    WIDTH 2

LINK tosw4
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    NODES sw2:W sw4:E
    TARGET /var/www/mrtg/sw2/10.42.242.15_40.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg1
    ARROWSTYLE 1 1
    BANDWIDTH 8000M
    BWFONT 43
    NODES sw1:W sw2:E
    TARGET /var/www/mrtg/sw1/10.42.242.13_49.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg2
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S ceph1:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_50.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg3
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S ceph2:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_51.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg4
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S vs4:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_52.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg5
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S vs2:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_53.rrd:ds0:ds1
    WIDTH 2

#LINK sw1lagg6
#    ARROWSTYLE 1 1
#    BANDWIDTH 4000M
##   BWFONT 43
#    BWLABEL none
#    NODES sw1:S vs5:N
#    TARGET /var/www/mrtg/sw1/10.42.242.13_54.rrd:ds0:ds1
#    WIDTH 2

LINK sw2lagg2
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph4:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_50.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg3
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph3:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_51.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg4
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S vs3:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_52.rrd:ds0:ds1
    WIDTH 2

LINK sw4lagg1
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw4:S vs5:NW
    TARGET /var/www/mrtg/sw4/10.42.242.6_49.rrd:ds0:ds1
    WIDTH 1

LINK sw2lagg5
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S vs1:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_53.rrd:ds0:ds1
    WIDTH 2

#LINK sw2lagg6
#    ARROWSTYLE 1 1
#    BANDWIDTH 4000M
#    BWFONT 43
#    NODES sw2:E sw3:SW
#    TARGET /var/www/mrtg/sw2/10.42.242.15_54.rrd:ds0:ds1
#    WIDTH 2

LINK ceph5nolagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S ceph5:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_11.rrd:ds0:ds1
    WIDTH 2

LINK ceph6nolagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S ceph6:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_12.rrd:ds0:ds1
    WIDTH 1

LINK ceph7nolagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph7:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_9.rrd:ds0:ds1
    WIDTH 1

LINK ceph8nolagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph8:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_10.rrd:ds0:ds1
    WIDTH 1

LINK store1lagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw3:S store1:N
    TARGET /var/www/mrtg/sw3/10.42.242.10_49.rrd:ds0:ds1
    WIDTH 1

LINK ceph1lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S ceph1:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_31.rrd:ds0:ds1
    WIDTH 1

LINK ceph2lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S ceph2:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_32.rrd:ds0:ds1
    WIDTH 1

LINK ceph3lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw2:S ceph3:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_32.rrd:ds0:ds1
    WIDTH 1

LINK ceph4lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw2:S ceph4:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_31.rrd:ds0:ds1
    WIDTH 1

LINK ceph5lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S ceph5:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_29.rrd:ds0:ds1
    WIDTH 1

LINK ceph6lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw1:S ceph6:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_30.rrd:ds0:ds1
    WIDTH 1

LINK ceph7lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph7:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_29.rrd:ds0:ds1
    WIDTH 1

LINK ceph8lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
#   BWFONT 43
    NODES sw2:S ceph8:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_30.rrd:ds0:ds1
    WIDTH 1

LINK vs1lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw2:S vs1:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_35.rrd:ds0:ds1
    WIDTH 1

LINK vs2lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S vs2:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_36.rrd:ds0:ds1
    WIDTH 1

LINK vs3lan1
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S vs3:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_37.rrd:ds0:ds1
    WIDTH 1

LINK vs3lan2
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw2:S vs3:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_37.rrd:ds0:ds1
    WIDTH 1

LINK vs4lan1
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S vs4:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_38.rrd:ds0:ds1
    WIDTH 1

LINK vs4lan2
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw2:S vs4:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_38.rrd:ds0:ds1
    WIDTH 1

LINK vs6lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw1:S vs6:N
    TARGET /var/www/mrtg/sw1/10.42.242.13_9.rrd:ds0:ds1
    WIDTH 1

LINK wifi1
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    BWLABELPOS 15 8
    NODES ap1:N sw1:S
    TARGET /var/www/mrtg/sw1/10.42.242.13_33.rrd:ds0:ds1
    WIDTH 2

LINK ssidguest1
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 35
    NODES ap1:W90 guestwifi
    TARGET /var/www/mrtg/asteros/10.42.242.11_3.rrd:ds0:ds1
    WIDTH 2

LINK ssidusers1
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 52
    NODES ap1:W90 userswifi
    TARGET /var/www/mrtg/asteros/10.42.242.11_14.rrd:ds0:ds1
    WIDTH 2

LINK ssidfaust1
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 35
    NODES ap1:W90 faustwifi
    TARGET /var/www/mrtg/asteros/10.42.242.11_13.rrd:ds0:ds1
    WIDTH 2

LINK wifi2
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    BWLABELPOS 15 8
    NODES ap2:N sw4:S
    TARGET /var/www/mrtg/sw4/10.42.242.6_5.rrd:ds0:ds1
    WIDTH 2

LINK ssidguest2
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 35
    NODES ap2:E90 guestwifi
    TARGET /var/www/mrtg/cerberus/10.42.242.26_18.rrd:ds0:ds1
    WIDTH 2

LINK ssidusers2
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 52
    NODES ap2:E90 userswifi
    TARGET /var/www/mrtg/cerberus/10.42.242.26_17.rrd:ds0:ds1
    WIDTH 2

LINK ssidfaust2
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 35
    NODES ap2:E90 faustwifi
    TARGET /var/www/mrtg/cerberus/10.42.242.26_16.rrd:ds0:ds1
    WIDTH 2

LINK tocam1
    ARROWSTYLE 1 1
    BANDWIDTH 100M
    BWFONT 43
    BWLABELPOS 70 25
    NODES cam1:N sw4:S
    TARGET /var/www/mrtg/cam1/10.42.40.100_2.rrd:ds0:ds1
    WIDTH 2

LINK tocam2
    ARROWSTYLE 1 1
    BANDWIDTH 100M
    BWFONT 43
    BWLABELPOS 70 25
    NODES cam2:N sw4:S
    TARGET /var/www/mrtg/cam2/10.42.40.101_2.rrd:ds0:ds1
    WIDTH 2
