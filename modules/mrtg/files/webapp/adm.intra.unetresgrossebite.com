var aps = {
    'asteros': {
	'alias': 'ap1',
	'ip': '10.42.242.11',
	'ifs': {
	    'Ethernet': '2',
	    'Guest': '3',
	    'Faust': '13',
	    'Users': '14'
	}
    },
    'cerberus': {
	'alias': 'ap2',
	'ip': '10.42.242.26',
	'ifs': {
	    'Ethernet': '15',
	    'Guest': '18',
	    'Faust': '16',
	    'Users': '17'
	}
    }
};
var cams = {
    'cam1': {
	'alias': 'entrance',
	'ip': '10.42.40.100',
	'ifs': {
	    'Ethernet': '2'
	}
    },
    'cam2': {
	'alias': 'window',
	'ip': '10.42.40.101',
	'ifs': {
	    'Ethernet': '2'
	}
    }
};
var firewalls = {
    'zeus': {
	'alias': 'fw1',
	'ip': '10.42.242.5',
	'ifs': {
	    'WAN-global': '1',
	    'WAN-Free': '10',
	    'WAN-Orange': '12',
	    'VLANs': '7',
	    'Admin': '14',
	    'Ceph': '8',
	    'Faust': '17',
	    'Friends': '18',
	    'Guests': '9',
	    'Plaristote': '20',
	    'SIP': '21',
	    'Users': '15',
	    'VMs': '16',
	    'VideoSurveillance': '13',
	    'WiFi': '19'
	}
    },
    'io': {
	'alias': 'fw2',
	'ip': '10.42.242.3',
	'ifs': {
	    'WAN-global': '1',
	    'WAN-Free': '10',
	    'WAN-Orange': '12',
	    'VLANs': '7',
	    'Admin': '14',
	    'Ceph': '8',
	    'Faust': '17',
	    'Friends': '18',
	    'Guests': '9',
	    'Plaristote': '20',
	    'SIP': '21',
	    'Users': '15',
	    'VMs': '16',
	    'VideoSurveillance': '13',
	    'WiFi': '19'
	}
    }
};
var sans = {
    'hesperus': {
	'alias': 'store1',
	'ip': '10.42.242.12',
	'ifs': {
	    'bge0': '1',
	    'bge1': '2',
	    'Admin': '5',
	    'VMs': '7',
	    'Faust': '6',
	    'Plaristote': '8',
	    'lagg0': '4'
	}
    }
};
var switches = {
    'sw1': {
	'alias': 'eros',
	'ip': '10.42.242.13',
	'ifs': {
	    'gaia LAGG1#1 (g1)': '1',
	    'gaia LAGG1#2 (g2)': '2',
	    'gaia LAGG1#3 (g3)': '3',
	    'gaia LAGG1#4 (g4)': '4',
	    'gaia LAGG1#5 (g5)': '5',
	    'gaia LAGG1#6 (g6)': '6',
	    'gaia LAGG1#7 (g7)': '7',
	    'gaia LAGG1#8 (g8)': '8',
	    'nyx ceph (g11)': '11',
	    'erebe ceph (g12)': '12',
	    'nyx (g29)': '29',
	    'erebe (g30)': '30',
	    'helios (g31)': '31',
	    'selene (g32)': '32',
	    'asteros (g33)': '33',
	    'rhea (g34)': '34',
	    'thanatos (g36)': '36',
	    'momos (g37)': '37',
	    'moros (g38)': '38',
	    'Fibre Orange (g39)': '39',
	    'to-nikea (g40)': '40',
	    'zeus WAN (g41)': '41',
	    'ADSL Free (g43)': '43',
	    'io WAN (g45)': '45',
	    'io LAGG8#1 (g46)': '46',
	    'io LAGG8#2 (g47)': '47',
	    'io LAGG8#3 (g48)': '48',
	    'to-gaia total (ch1)': '49',
	    'helios total (ch2)': '50',
	    'selene total (ch3)': '51',
	    'moros total (ch4)': '52',
	    'thanatos total (ch5)': '53',
	    'oneiroi total (ch6)': '54',
	    'io total (ch8)': '56'
	}
    },
    'sw2': {
	'alias': 'gaia',
	'ip': '10.42.242.15',
	'ifs': {
	    'eros LAGG1#1 (g1)': '1',
	    'eros LAGG1#2 (g2)': '2',
	    'eros LAGG1#3 (g3)': '3',
	    'eros LAGG1#4 (g4)': '4',
	    'eros LAGG1#5 (g5)': '5',
	    'eros LAGG1#6 (g6)': '6',
	    'eros LAGG1#7 (g7)': '7',
	    'eros LAGG1#8 (g8)': '8',
	    'aether ceph (g9)': '9',
	    'ouranos ceph (g10)': '10',
	    'hemara ceph LAGG2#1 (g11)': '11',
	    'hemara ceph LAGG2#2 (g12)': '12',
	    'eos ceph LAGG3#1 (g13)': '13',
	    'eos ceph LAGG3#2 (g14)': '14',
	    'eos ceph LAGG3#3 (g15)': '15',
	    'eos ceph LAGG3#4 (g16)': '16',
	    'momos ceph LAGG4#1 (g17)': '17',
	    'momos ceph LAGG4#2 (g18)': '18',
	    'momos ceph LAGG4#3 (g19)': '19',
	    'momos ceph LAGG4#4 (g20)': '20',
	    'nemesis ceph LAGG5#1 (g21)': '21',
	    'nemesis ceph LAGG5#2 (g22)': '22',
	    'nemesis ceph LAGG5#3 (g23)': '23',
	    'nemesis ceph LAGG5#4 (g24)': '24',
	    'aether (g29)': '29',
	    'ouranos (g30)': '30',
	    'hemara (g31)': '31',
	    'eos (g32)': '32',
	    'hestia (g33)': '33',
	    'hera (g34)': '34',
	    'nemesis (g35)': '35',
	    'oneiroi (g36)': '36',
	    'momos (g37)': '37',
	    'moros (g38)': '38',
	    'to-videosurveillance (g39)': '39',
	    'to-ponos (g40)': '40',
	    'zeus LAGG8#1 (g42)': '46',
	    'zeus LAGG8#2 (g43)': '47',
	    'zeus LAGG8#3 (g44)': '48',
	    'to-gaia total (ch1)': '49',
	    'hemara total (ch2)': '50',
	    'eos total (ch3)': '51',
	    'momos total (ch4)': '52',
	    'nemesis total (ch5)': '53',
	    'zeus total (ch8)': '56'
	}
    },
    'sw3': {
	'alias': 'nikea',
	'ip': '10.42.242.10',
	'ifs': {
	    'SIP (g1)': '1',
	    'RPI (g2)': '2',
	    'alpha (g13)': '13',
	    'lachesis (g14)': '14',
	    'zaza (g15)': '15',
	    'hesperus LAGG1#1 (g21)': '21',
	    'hesperus LAGG1#2 (g22)': '22',
	    'eros (g24)': '24',
	    'hesperus total (ch1)': '49'
	}
    },
    'sw4': {
	'alias': 'ponos',
	'ip': '10.42.242.6',
	'ifs': {
	    'cam1 (g1)': '1',
	    'cam2 (g2)': '2',
	    'oneiroi LAGG1#1 (g3)': '3',
	    'oneiroi LAGG1#2 (g4)': '4',
	    'cerberus (g5)': '5',
	    'laptops (g11)': '11',
	    'to-gaia (g24)': '24',
	    'oneiroi LAGG#1 total (ch1)': '49'
	}
    }
};
