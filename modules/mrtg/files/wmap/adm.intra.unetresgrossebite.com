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
    LABEL Poseidon
    LABELFONT 42
    LABELOFFSET E
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/fw.png

NODE sw1
    POSITION 550 300
    LABEL Eros
    LABELFONT 42
    LABELOFFSET NE
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw2
    POSITION 250 300
    LABEL Gaia
    LABELFONT 42
    LABELOFFSET NW
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw3
    POSITION 700 300
    LABEL Nikea
    LABELFONT 42
    LABELOFFSET NW
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE sw4
    POSITION 100 300
    LABEL Ponos
    LABELFONT 42
    LABELOFFSET NE
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/sw.png

NODE cam1
    POSITION 70 110
    LABEL cam1
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/camera.png

NODE cam2
    POSITION 130 110
    LABEL cam2
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/camera.png

NODE vs1
    POSITION 280 490
    LABEL Nemesis
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs2
    POSITION 520 490
    LABEL Thanatos
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs3
    LABEL Momos
    POSITION 360 490
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs4
    POSITION 440 490
    LABEL Moros
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs6
    POSITION 400 345
    LABEL Oizis
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs7
    POSITION 320 595
    LABEL Crios
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs8
    POSITION 440 595
    LABEL Phoebe
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs9
    POSITION 240 595
    LABEL Aether
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE vs10
    POSITION 560 595
    LABEL Erebe
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

NODE vs5
    POSITION 200 450
    LABEL Oneiroi
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/server.png

NODE ceph1
    POSITION 52 450
    LABEL Helios
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

#NODE ceph1disk1
#    LABEL ceph-00
#    POSITION ceph1 0 60
#    TARGET gauge:/var/www/mrtg/helios/10.42.242.14.disk.58.rrd:ds0:ds1
#    MAXVALUE 1.9T

#NODE ceph1disk2
#    LABEL ceph-12
#    POSITION ceph1 0 80
#    TARGET gauge:/var/www/mrtg/helios/10.42.242.14.disk.57.rrd:ds0:ds1
#    MAXVALUE 927G

#NODE ceph1disk3
#    LABEL ceph-20
#    POSITION ceph1 0 100
#    TARGET gauge:/var/www/mrtg/helios/10.42.242.14.disk.56.rrd:ds0:ds1
#    MAXVALUE 927G

NODE ceph2
    POSITION 102 450
    LABEL Selene
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

#NODE ceph2disk1
#    LABEL ceph-01
#    POSITION ceph2 0 60
#    TARGET gauge:/var/www/mrtg/selene/10.42.242.16.disk.56.rrd:ds0:ds1
#    MAXVALUE 1.9T

#NODE ceph2disk2
#    LABEL ceph-11
#    POSITION ceph2 0 80
#    TARGET gauge:/var/www/mrtg/selene/10.42.242.16.disk.58.rrd:ds0:ds1
#    MAXVALUE 927G

#NODE ceph2disk3
#    LABEL ceph-22
#    POSITION ceph2 0 100
#    TARGET gauge:/var/www/mrtg/selene/10.42.242.16.disk.57.rrd:ds0:ds1
#    MAXVALUE 2.8T

NODE ceph3
    POSITION 152 450
    LABEL Nyx
    LABELFONT 42
    LABELOFFSET S
    LABELOUTLINECOLOR 255 255 255
    ICON 60 60 /var/www/wmap/images/disk.png

#NODE ceph3disk1
#    LABEL ceph-26
#    POSITION ceph3 0 60
#    TARGET gauge:/var/www/mrtg/nyx/10.42.242.18.disk.56.rrd:ds0:ds1
#    MAXVALUE 470G

#NODE ceph3disk2
#    LABEL ceph-27
#    POSITION ceph3 0 80
#    TARGET gauge:/var/www/mrtg/nyx/10.42.242.18.disk.57.rrd:ds0:ds1
#    MAXVALUE 3.7T

#NODE ceph3disk3
#    LABEL ceph-28
#    POSITION ceph3 0 100
#    TARGET gauge:/var/www/mrtg/nyx/10.42.242.18.disk.58.rrd:ds0:ds1
#    MAXVALUE 3.7T

#NODE ceph3disk4
#    LABEL ceph-29
#    POSITION ceph3 0 120
#    TARGET gauge:/var/www/mrtg/nyx/10.42.242.18.disk.59.rrd:ds0:ds1
#    MAXVALUE 3.7T

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
    BANDWIDTH 185M 106M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw1:N fibreorange
    TARGET /var/www/mrtg/zeus/10.42.242.5_26.rrd:ds0:ds1
    WIDTH 3

LINK fw2orange
    ARROWSTYLE 1 1
    BANDWIDTH 185M 106M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw2:N fibreorange
    TARGET /var/www/mrtg/poseidon/10.42.242.2_26.rrd:ds0:ds1
    WIDTH 3

LINK fw1free
    ARROWSTYLE 1 1
    BANDWIDTH 106M 111M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw1:N fibrefree
    TARGET /var/www/mrtg/zeus/10.42.242.5_25.rrd:ds0:ds1
    WIDTH 3

LINK fw2free
    ARROWSTYLE 1 1
    BANDWIDTH 106M 111M
    BWFONT 43
    BWLABELPOS 35 20
    NODES fw2:N fibrefree
    TARGET /var/www/mrtg/poseidon/10.42.242.2_25.rrd:ds0:ds1
    WIDTH 3

LINK tosw3
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    NODES sw1:E sw3:W
    TARGET /var/www/mrtg/sw1/10.42.242.4_39.rrd:ds0:ds1
    WIDTH 2

LINK tosw4
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    NODES sw2:W sw4:E
    TARGET /var/www/mrtg/sw2/10.42.242.15_92.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg1
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw1:S vs3:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1000.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg2
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw1:S vs4:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1001.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg3
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw1:S vs8:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1002.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg4
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw1:S vs7:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1003.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg5
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw1:W vs6:E
    TARGET /var/www/mrtg/sw1/10.42.242.4_1004.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg6
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw1:S vs2:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1005.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg7
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw1:S vs1:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1006.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg8
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw1:S vs9:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1007.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg9
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw1:S vs10:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1008.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg29
    ARROWSTYLE 1 1
    BANDWIDTH 8000M
    BWFONT 43
    NODES sw1:W sw2:E
    TARGET /var/www/mrtg/sw1/10.42.242.4_1028.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg30
    ARROWSTYLE 1 1
    BANDWIDTH 20000M
    BWFONT 43
    NODES sw1:N sw2:N
    TARGET /var/www/mrtg/sw1/10.42.242.4_1029.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg31
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWFONT 43
    NODES sw1:N fw2:S
    TARGET /var/www/mrtg/sw1/10.42.242.4_1030.rrd:ds0:ds1
    WIDTH 2

LINK sw1lagg32
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWFONT 43
    NODES sw1:N fw1:S
    TARGET /var/www/mrtg/sw1/10.42.242.4_1031.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg1
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw2:S vs3:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1000.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg2
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw2:S vs4:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1001.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg3
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw2:S vs8:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1002.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg4
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw2:S vs7:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1003.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg5
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw2:E vs6:W
    TARGET /var/www/mrtg/sw2/10.42.242.15_1004.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg6
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw2:S vs2:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1005.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg7
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWLABEL none
    NODES sw2:S vs1:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1006.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg8
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw2:S vs9:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1007.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg9
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWLABEL none
    NODES sw2:S vs10:N
    TARGET /var/www/mrtg/sw2/10.42.242.15_1008.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg31
    ARROWSTYLE 1 1
    BANDWIDTH 4000M
    BWFONT 43
    NODES sw2:N fw2:S
    TARGET /var/www/mrtg/sw2/10.42.242.15_1030.rrd:ds0:ds1
    WIDTH 2

LINK sw2lagg32
    ARROWSTYLE 1 1
    BANDWIDTH 2000M
    BWFONT 43
    NODES sw2:N fw1:S
    TARGET /var/www/mrtg/sw2/10.42.242.15_1031.rrd:ds0:ds1
    WIDTH 2

LINK store1lagg
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw3:S store1:N
    TARGET /var/www/mrtg/sw3/10.42.242.10_49.rrd:ds0:ds1
    WIDTH 1

LINK ceph1lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw4:S ceph1:N
    TARGET /var/www/mrtg/sw4/10.42.242.6_13.rrd:ds0:ds1
    WIDTH 1

LINK ceph2lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw4:S ceph2:N
    TARGET /var/www/mrtg/sw4/10.42.242.6_12.rrd:ds0:ds1
    WIDTH 1

LINK ceph3lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw4:S ceph3:N
    TARGET /var/www/mrtg/sw4/10.42.242.6_14.rrd:ds0:ds1
    WIDTH 1

LINK vs5lan
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWLABEL none
    NODES sw4:S vs5:N
    TARGET /var/www/mrtg/sw4/10.42.242.6_3.rrd:ds0:ds1
    WIDTH 1

LINK wifi1
    ARROWSTYLE 1 1
    BANDWIDTH 1000M
    BWFONT 43
    BWLABELPOS 15 8
    NODES ap1:N sw1:S
    TARGET /var/www/mrtg/sw1/10.42.242.4_33.rrd:ds0:ds1
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

LINK ssidfaust2
    ARROWSTYLE 1 1
    BANDWIDTH 56M
    BWFONT 43
    BWLABELPOS 78 35
    NODES ap2:E90 faustwifi
    TARGET /var/www/mrtg/cerberus/10.42.242.26_8.rrd:ds0:ds1
    WIDTH 2

LINK tocam1
    ARROWSTYLE 1 1
    BANDWIDTH 100M
    BWFONT 43
    BWLABELPOS 70 25
    NODES cam1:S sw4:N
    TARGET /var/www/mrtg/cam1/10.42.40.100_2.rrd:ds0:ds1
    WIDTH 2

LINK tocam2
    ARROWSTYLE 1 1
    BANDWIDTH 100M
    BWFONT 43
    BWLABELPOS 70 25
    NODES cam2:S sw4:N
    TARGET /var/www/mrtg/cam2/10.42.40.101_2.rrd:ds0:ds1
    WIDTH 2
