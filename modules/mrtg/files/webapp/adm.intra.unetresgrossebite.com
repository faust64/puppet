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
	    'Ethernet': '2',
	    'Faust': '26'
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
	    'WAN-Free': '25',
	    'WAN-Orange': '26',
	    'VLANs': '22',
	    'Admin': '28',
	    'Ceph': '23',
	    'Faust': '31',
	    'Friends': '32',
	    'Guests': '24',
	    'Plaristote': '34',
	    'SIP': '35',
	    'Users': '29',
	    'VMs': '30',
	    'VideoSurveillance': '27',
	    'WiFi': '33'
	}
    },
    'poseidon': {
	'alias': 'fw2',
	'ip': '10.42.242.2',
	'ifs': {
	    'WAN-Free': '25',
	    'WAN-Orange': '26',
	    'VLANs': '22',
	    'Admin': '28',
	    'Ceph': '23',
	    'Faust': '31',
	    'Friends': '32',
	    'Guests': '24',
	    'Plaristote': '34',
	    'SIP': '35',
	    'Users': '29',
	    'VMs': '30',
	    'VideoSurveillance': '27',
	    'WiFi': '33'
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
	'ip': '10.42.242.4',
	'ifs': {
	    'gaia LAG29#1 (g1)': '1',
	    'gaia LAG29#2 (g2)': '2',
	    'gaia LAG29#3 (g3)': '3',
	    'gaia LAG29#4 (g4)': '4',
	    'gaia LAG29#5 (g5)': '5',
	    'gaia LAG29#6 (g6)': '6',
	    'gaia LAG29#7 (g7)': '7',
	    'gaia LAG29#8 (g8)': '8',
	    'gaia LAG30#1 (t1)': '49',
	    'gaia LAG30#2 (t2)': '50',
	    'momos LAG1#1 (g11)': '11',
	    'momos LAG1#2 (g12)': '12',
	    'momos LAG1#3 (g13)': '13',
	    'momos LAG1#4 (g14)': '14',
	    'phoebe LAG3#1 (g15)': '15',
	    'phoebe LAG3#2 (g16)': '16',
	    'oizis LAG5#1 (g17)': '17',
	    'oizis LAG5#2 (g18)': '18',
	    'nemesis LAG7#1 (g19)': '19',
	    'nemesis LAG7#2 (g20)': '20',
	    'nemesis LAG7#3 (g21)': '21',
	    'nemesis LAG7#4 (g22)': '22',
	    'erebe LAG9#1 (g23)': '23',
	    'erebe LAG9#2 (g24)': '24',
	    'hera (g35)': '35',
	    'hestia (g37)': '37',
	    'to-nikea (g39)': '39',
	    'Fibre Orange (g41)': '41',
	    'zeus LAG31#1 (g45)': '45',
	    'zeus LAG31#1 (g46)': '46',
	    'zeus LAG31#2 (g47)': '47',
	    'zeus LAG31#3 (g48)': '48',
	    'momos total (ch1)': '1000',
	    'phoebe total (ch3)': '1002',
	    'oizis total (ch5)': '1004',
	    'nemesis total (ch7)': '1006',
	    'erebe total (ch9)': '1008',
	    'zeus total (ch31)': '1030',
	    'to-gaia ethernet total (29)': '10028',
	    'to-gaia fiber total (30)': '10029'
	}
    },
    'sw2': {
	'alias': 'gaia',
	'ip': '10.42.242.15',
	'ifs': {
	    'eros LAGG1#1 (g1)': '53',
	    'eros LAGG1#2 (g2)': '54',
	    'eros LAGG1#3 (g3)': '55',
	    'eros LAGG1#4 (g4)': '56',
	    'eros LAGG1#5 (g5)': '57',
	    'eros LAGG1#6 (g6)': '58',
	    'eros LAGG1#7 (g7)': '59',
	    'eros LAGG1#8 (g8)': '60',
	    'moros LAG2#1 (g11)': '63',
	    'moros LAG2#2 (g12)': '64',
	    'moros LAG2#3 (g13)': '65',
	    'moros LAG2#4 (g14)': '66',
	    'crios LAG4#1 (g15)': '67',
	    'crios LAG4#2 (g16)': '68',
	    'thanatos LAG6#1 (g17)': '69',
	    'thanatos LAG6#2 (g18)': '70',
	    'thanatos LAG6#3 (g19)': '71',
	    'thanatos LAG6#4 (g20)': '72',
	    'aether LAG8#1 (g21)': '73',
	    'aether LAG8#2 (g22)': '74',
	    'nyx LAG10#1 (g30)': '81',
	    'nyx LAG10#2 (g31)': '82',
	    'rhea (g36)': '88',
	    'asteros (g38)': '90',
	    'to-ponos (g40)': '92',
	    'ADSL Free (g42)': '94',
	    'poseidon LAG32#1 (g43)': '95',
	    'poseidon LAG32#2 (g44)': '96',
	    'poseidon LAG32#3 (g45)': '97',
	    'poseidon LAG32#4 (g46)': '98',
	    'moros total (ch2)': '1001',
	    'crios total (ch4)': '1003',
	    'thanatos total (ch6)': '1005',
	    'aether total (ch8)': '1007',
	    'nyx total (ch10)': '1009',
	    'poseidon total (ch32)': '1031',
	    'to-eros ethernet total (29)': '10028',
	    'to-eros fiber total (30)': '10029'
	}
    },
    'sw3': {
	'alias': 'nikea',
	'ip': '10.42.242.10',
	'ifs': {
	    'SIP (g1)': '1',
	    'alpha (g13)': '13',
	    'lachesis (g14)': '14',
	    'zaza (g15)': '15',
	    'hesperus LAG1#1 (g21)': '21',
	    'hesperus LAG1#2 (g22)': '22',
	    'to-eros (g24)': '24',
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
	    'rpi-b (g6)': '6',
	    'rpi-rack1-unit1 thalia (g7)': '7',
	    'rpi-rack1-unit2 clio (g8)': '8',
	    'rpi-rack1-unit3 melpomene (g9)': '9',
	    'rpi-rack1-unit4 pyrrha (g10)': '10',
	    'laptops (g11)': '11',
	    'hemara (g12)': '12',
	    'helios (g13)': '13',
	    'selene (g14)': '14',
	    'rpi-rack2-unit1 erato (g15)': '15',
	    'rpi-rack2-unit2 polyhymnia (g16)': '16',
	    'rpi-rack2-unit3 urania (g17)': '17',
	    'rpi-rack2-unit4 epimethee (g18)': '18',
	    'rpi-rack3-unit1 pandore (g19)': '19',
	    'rpi-rack3-unit2 terpsichore (g20)': '20',
	    'rpi-rack3-unit3 euterpe (g21)': '21',
	    'rpi-rack4-unit4 clio (g22)': '22',
	    'to-gaia (g24)': '24',
	    'oneiroi LAGG#1 total (ch1)': '49'
	}
    }
};
