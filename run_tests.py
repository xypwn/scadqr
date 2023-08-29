#!/usr/bin/python

import argparse
import subprocess

class col:
    RESET = '\033[m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    BRED = '\033[1;31m'
    BGREEN = '\033[1;32m'

tests = [
    ['all', 'https://openscad.org/cheatsheet/'],
    ['wifi_WPA', 'WIFI:T:WPA;S:wifi_network;P:1234;;'],
    ['wifi2_WPA', 'WIFI:T:WPA;S:wireless_fidelity;P:PigOtter;;'],
    ['wifi_WEP', 'WIFI:T:WEP;S:wifi_network;P:1234;;'],
    ['wifi_nopass', 'WIFI:T:nopass;S:wifi_network;P:;;'],
    ['wifi_hidden', 'WIFI:T:WPA;S:wifi_network;P:1234;H:true;'],
    ['phone', 'TEL:+33 1 23 45 67 89'],
    ['text_utf8', 'lorem ipsum'],
    ['text_Shift_JIS', '|orem ipsum'],
    ['error_correction_M', 'lorem ipsum1'],
    ['error_correction_Q', 'lorem ipsum2'],
    ['error_correction_H', 'lorem ipsum3'],
    ['mask_pattern_1', 'lorem ipsum_1'],
    ['mask_pattern_2', 'lorem ipsum_2'],
    ['mask_pattern_3', 'lorem ipsum_3'],
    ['mask_pattern_4', 'lorem ipsum_4'],
    ['mask_pattern_5', 'lorem ipsum_5'],
    ['mask_pattern_6', 'lorem ipsum_6'],
    ['mask_pattern_7', 'lorem ipsum_7'],
]

argparser = argparse.ArgumentParser(prog='test.py',description='Run ScadQR tests')
argparser.add_argument('-s', '--openscad', default='openscad', help='OpenSCAD executable')
argparser.add_argument('-z', '--zbarimg', default='zbarimg', help='zbarimg QR code reader executable')
args = argparser.parse_args()

def exe_not_found(name, path, flag):
    print(f'{name} executable at "{path}" not found.')
    print(f'Please install {name} or use the "{flag}" flag to specify a custom executable.')

print('Running tests...')

tests_passed = 0
for i, test in enumerate(tests):
    testname = test[0]
    expect = 'QR-Code:'+test[1]

    print(f' {i}/{len(tests)}', end='\r')

    img = ''
    try:
        img = subprocess.check_output([
            args.openscad,
            '-q',
            '--autocenter',
            '--viewall',
            '--camera=0,0,0,0,0,0,200',
            '-p', 'tests.json',
            '-P', testname,
            '--export-format', 'png',
            '-o', '-',
            'demo.scad',
        ])
    except FileNotFoundError:
        exe_not_found('OpenSCAD', args.openscad, '-s')
        exit()

    res = ''
    try:
        res = subprocess.check_output([
            args.zbarimg,
            '-q',
            '-',
        ], input=img).decode('utf-8').removesuffix('\n')
    except FileNotFoundError:
        exe_not_found('zbarimg', args.zbarimg, '-z')
        exit()

    if (res == expect):
        tests_passed += 1
    else:
        print(f'{col.RED}failed{col.RESET} test "{testname}": got "{res}", expected "{expect}"')

if tests_passed == len(tests):
    print(f'{col.BGREEN}PASS{col.RESET} {tests_passed}/{len(tests)} tests passed')
else:
    print(f'{col.BRED}FAIL{col.RESET} {len(tests) - tests_passed}/{len(tests)} tests failed')
    exit(1)
