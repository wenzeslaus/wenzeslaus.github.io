#!/usr/bin/python

import sys
import fileinput
import re

replacements = [
    (re.compile(r'<a href.*>(.*)</a>'), r'\1'),
    (re.compile(r'<img .*>'), r''),
    (re.compile(r'<ul.*>'), r''),
    (re.compile(r'</ul>'), r''),
    (re.compile(r'<li>'), r''),
    (re.compile(r'</li>'), r''),
    (re.compile(r'<h4>(.*)</h4>'), r'<h3>\1</h3>'),
]

for line in fileinput.input():
    for replacemet in replacements:
        line = replacemet[0].sub(replacemet[1], line)
    sys.stdout.write(line)
