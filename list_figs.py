#! /usr/bin/env python
# list_figs.py <filename>
#
# Find figure files required by LaTeX source file <filename> via
# \includegraphics macros.

import re
from StringIO import StringIO
import sys, glob, fileinput

fig_re = re.compile(r'\includegraphics\S*{(?P<fig>[\w,\-,+,/,.]*)}')

sample = r"""
blah  \includegraphics[angle=-90,width=.5\textwidth]{posterior_f_all_margOverKappa.eps} &
\includegraphics[angle=-90,width=.5\textwidth]{fig2.eps} & \includegraphics[angle=-90,width=.5\textwidth]{fig3.eps}

%\centerline{\includegraphics[width=210pt,height=190pt]{f9.eps}}
\centerline{\includegraphics[width=210pt,height=190pt]{f5.eps}}
"""
    


# For multiple args, treat as a file list; otherwise as a glob.
if len(sys.argv) > 2:
    lines = fileinput.input()
elif len(sys.argv) == 2:
    lines = fileinput.input(glob.glob(sys.argv[1]))
else:
    lines = StringIO(sample)

print 'Figure files found (presuming simple names, 1/line, may include comments):'
nl = 0
nf = 0
found = {}
for line in lines:
    nl += 1
    line = line.strip()
    if not line:
        continue
    # Skip entirely commented lines.
    if line[0] == '%':
        continue
    results = fig_re.findall(line)
    c = line.count('includegraphics')
    if c > 1:
        print '*** Multiple figures on a line! ***'
    for result in results:
        # Count and print only unique filenames.
        if result in found:
            continue
        found[result] = True
        nf += 1
        print result
print '[%d lines read, %d unique figure references found]' % (nl, nf)
