#!/usr/bin/python

import argparse
import os
import re

# maximum character count in 8-bit byte encoding by version and error correction levels
maxchars = [
    [17, 14, 11, 7],
    [32, 26, 20, 14],
    [53, 42, 32, 24],
    [78, 62, 46, 34],
    [106, 84, 60, 44],
    [134, 106, 74, 58],
    [154, 122, 86, 64],
    [192, 152, 108, 84],
    [230, 180, 130, 98],
    [271, 213, 151, 119],
    [321, 251, 177, 137],
    [367, 287, 203, 155],
    [425, 331, 241, 177],
    [458, 362, 258, 194],
    [520, 412, 292, 220],
    [586, 450, 322, 250],
    [644, 504, 364, 280],
    [718, 560, 394, 310],
    [792, 624, 442, 338],
    [858, 666, 482, 382],
    [929, 711, 509, 403],
    [1003, 779, 565, 439],
    [1091, 857, 611, 461],
    [1171, 911, 661, 511],
    [1273, 997, 715, 535],
    [1367, 1059, 751, 593],
    [1465, 1125, 805, 625],
    [1528, 1190, 868, 658],
    [1628, 1264, 908, 698],
    [1732, 1370, 982, 742],
    [1840, 1452, 1030, 790],
    [1952, 1538, 1112, 842],
    [2068, 1628, 1168, 898],
    [2188, 1722, 1228, 958],
    [2303, 1809, 1283, 983],
    [2431, 1911, 1351, 1051],
    [2563, 1989, 1423, 1093],
    [2699, 2099, 1499, 1139],
    [2809, 2213, 1579, 1219],
    [2953, 2331, 1663, 1273]
]

prolog = """//
//   ########                        ##   #######    #######  
//  ##//////                        /##  ##/////##  /##////## 
// /##         #####   ######       /## ##     //## /##   /## 
// /######### ##///## //////##   ######/##      /## /#######  
// ////////##/##  //   #######  ##///##/##    ##/## /##///##  
//        /##/##   ## ##////## /##  /##//##  // ##  /##  //## 
//  ######## //##### //########//###### //####### ##/##   //##
// ////////   /////   ////////  //////   /////// // //     // 
//
// Versions 1-{max_version}
// Error Correction | Max Characters
// -----------------|---------------
// Low (~7%)        | {max_chars_l}
// Medium (~15%)    | {max_chars_m}
// Quartile (~25%)  | {max_chars_q}
// High (~30%)      | {max_chars_h}
//
// Effortlessly generate QR codes directly in OpenSCAD
// https://github.com/xypwn/scadqr
//
// Copyright (c) 2023 Darwin Schuppan. All rights reserved.
//
// This work is licensed under the terms of the MIT license.  
// For a copy, see <https://opensource.org/licenses/MIT>.
"""

def generate(outfile, outdocfile, infiles):
    docdefs = []
    privatenames = []
    for fname in infiles:
        with open(fname) as infile:
            public = False
            comment = ''
            for line in infile:
                if comment == '@PUBLIC\n':
                    public = True
                if comment == '@PRIVATE\n':
                    public = False
                iscomment = line.startswith('//')
                match = re.match(r'(?:(function|module) (\w+) ?\(([^\)]*)\))|(?:(\w+) ?=)', line)
                if match is not None:
                    m = match.groups()
                    isfn = m[0] is not None # is function or module
                    if public:
                        if isfn:
                            args = []
                            kind = m[0]
                            for arg in m[2].split(','):
                                name, default = arg.strip().partition('=')[::2]
                                description = ''
                                for l in comment.split('\n'):
                                    if l.startswith(name+':'):
                                        description = l.removeprefix(name+':').strip().replace('_', '\\_')
                                args.append((name, default, description))
                            docdefs.append((m[0], m[1], comment.partition('\n')[0], args))
                    else:
                        privatenames.append((m[1] or m[3], isfn))
                if iscomment:
                    comment += line.removeprefix('//').strip(' \t')
                else:
                    comment = ''

    with open(outdocfile, 'w') as doc:
        doc.write('# API Documentation\n')
        docdefs.sort(key=lambda x: 0 if x[0] == 'module' else 1)
        section = 'module'
        doc.write('### Modules\n')
        for d in docdefs:
            if d[0] != section and d[0] == 'function':
                doc.write('---\n')
                doc.write('### Functions\n')
                section = d[0]
            doc.write('---\n')
            doc.write('#### '+d[1].replace('_', '\\_')+' - '+d[2]+'\n')
            doc.write('```scad\n')
            doc.write(d[0]+' '+d[1]+'(')
            doc.write(', '.join(
                arg[0]+ (('='+arg[1]) if arg[1] != '' else '')
                for arg in d[3])+')\n')
            doc.write('```\n')
            doc.write('Parameters:\n')
            doc.write('|Name|Default|Description|\n')
            doc.write('|-|-|-|\n')
            for arg in d[3]:
                doc.write('|`'+arg[0]+
                         '`|'+('`'+arg[1]+'`' if arg[1] != '' else '*required*')+
                          '|'+arg[2]+'|\n')
        doc.write('---\n')

    with open(outfile, 'w') as out:
        out.write('//\n// Automatically generated by generate.py\n//\n')
        for fname in infiles:
            with open(fname) as infile:
                for line in infile:
                    match = re.match(r'include <(\w+\.scad)>', line)
                    if match is not None:
                        incname = match.groups()[0]
                        if any(os.path.basename(f) == incname for f in infiles):
                            continue
                    for pn in privatenames:
                        if pn[1]:
                            line = re.sub('(^|[^\w])'+pn[0]+'( ?\()', r'\1_qr_'+pn[0]+r'\2', line)
                        else:
                            line = re.sub('(^|[^\w])'+pn[0], r'\1_qr_'+pn[0], line)
                    out.write(line)

def add_prolog(file, max_version):
    s = prolog.format(
        max_version=max_version,
        max_chars_l=maxchars[max_version-1][0],
        max_chars_m=maxchars[max_version-1][1],
        max_chars_q=maxchars[max_version-1][2],
        max_chars_h=maxchars[max_version-1][3]
    )
    data = ''
    with open(file, 'r') as inf: data = inf.read()
    with open(file, 'w') as outf: outf.write(s+'\n'+data)

def strip_to_max_version(outfile, infile, max_version):
    with open(infile) as f, open(outfile, 'w') as out:
        reached = False
        vers_written = 0
        for line in f:
            if line.startswith('_qr_bit_indices = '):
                reached = True
            if reached:
                if line == '    ],\n':
                    vers_written += 1
                elif line == '    ]\n':
                    reached = False
            if not reached or vers_written < max_version:
                out.write(line)

argparser = argparse.ArgumentParser(prog='generate.py',description='Generate library file and docs for ScadQR')
argparser.add_argument('-c', '--clean', action='store_true')
args = argparser.parse_args()

if args.clean:
    os.remove('qr-40.scad')
    os.remove('qr-30.scad')
    os.remove('qr-20.scad')
    os.remove('qr-10.scad')
    os.remove('API.md')
else:
    generate('qr-40.scad', 'API.md', ['src/qr.scad', 'src/bits.scad', 'src/data.scad'])
    strip_to_max_version('qr-30.scad', 'qr-40.scad', 30)
    strip_to_max_version('qr-20.scad', 'qr-40.scad', 20)
    strip_to_max_version('qr-10.scad', 'qr-40.scad', 10)
    add_prolog('qr-40.scad', 40)
    add_prolog('qr-30.scad', 30)
    add_prolog('qr-20.scad', 20)
    add_prolog('qr-10.scad', 10)
