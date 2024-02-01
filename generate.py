#!/usr/bin/python

import argparse
import os
import re

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
// Effortlessly generate QR codes directly in OpenSCAD
// https://github.com/xypwn/scadqr
//
// Copyright (c) 2024 Darwin Schuppan. All rights reserved.
//
// This work is licensed under the terms of the MIT license.  
// For a copy, see <https://opensource.org/licenses/MIT>.
"""

def generate(outfile, outdocfile, prolog, infiles):
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
                            lines = comment.split('\n')
                            arglines = {}
                            args = []
                            kind = m[0]
                            for arg in m[2].split(','):
                                name, default = arg.strip().partition('=')[::2]
                                description = ''
                                for i, l in enumerate(lines):
                                    if l.startswith(name+':'):
                                        description = l.removeprefix(name+':').strip().replace('_', '\\_')
                                        arglines[i] = True;
                                args.append((name, default, description))
                            fndesc = ''
                            for i, l in enumerate(lines):
                                if i not in arglines and i != 0 and l != '':
                                    fndesc += l+'\n\n'
                            docdefs.append((m[0], m[1], comment.partition('\n')[0], fndesc, args))
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
                for arg in d[4])+')\n')
            doc.write('```\n')
            if d[3] != '':
                doc.write('###### Description:\n')
                doc.write(d[3].replace('_', '\\_'))
            doc.write('###### Parameters:\n')
            doc.write('|Name|Default|Description|\n')
            doc.write('|-|-|-|\n')
            for arg in d[4]:
                doc.write('|`'+arg[0]+
                         '`|'+('`'+arg[1]+'`' if arg[1] != '' else '*required*')+
                          '|'+arg[2]+'|\n')
        doc.write('---\n')

    with open(outfile, 'w') as out:
        out.write('//\n// Automatically generated by generate.py\n//\n\n')
        out.write(prolog+'\n')
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

argparser = argparse.ArgumentParser(prog='generate.py',description='Generate library file and docs for ScadQR')
argparser.add_argument('-c', '--clean', action='store_true')
args = argparser.parse_args()

if args.clean:
    os.remove('qr.scad')
    os.remove('API.md')
else:
    generate('qr.scad', 'API.md', prolog, ['src/qr.scad', 'src/bits.scad', 'src/data.scad'])
