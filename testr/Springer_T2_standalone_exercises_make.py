#!/usr/bin/env python
# Compile all stand-alone exercises to latex and ipynb

import os, sys

def os_system(cmd):
    '''Run system command cmd using the simple os_system command.'''
    print(cmd)
    failure = os.system(cmd)
    if failure:
        print('Command failed:\n'
              '  %s\n' % cmd)
        sys.exit(1)

dofiles = ["Chapter_2.1.do.txt", "Chapter_2.2.do.txt", "solutions.do.txt"]

for dofile in dofiles:
    # Compile to pdflatex
    cmd = 'doconce format pdflatex %s --latex_code_style=vrb --figure_prefix=../ --movie_prefix=../ --allow_refs_to_external_docs --examples_as_exercises' % dofile
    os.system(cmd)
    # Edit .tex file and remove doconce-specific comments
    cmd = 'doconce subst "%% #.+" "" %s.tex' % dofile[:-7]  # preprocess
    os.system(cmd)
    cmd = 'doconce subst "%%.*" "" %s.tex' % dofile[:-7]
    os.system(cmd)
    # Compile to ipynb
    cmd = 'doconce format ipynb %s --figure_prefix=../  --movie_prefix=../ --allow_refs_to_external_docs --examples_as_exercises' % dofile
    os.system(cmd)
    # Compile to html
    cmd = 'doconce format html %s --figure_prefix=../  --movie_prefix=../ --allow_refs_to_external_docs --examples_as_exercises' % dofile
    os.system(cmd)

# Clean up
cmd = 'rm *~ *.dlog'
os.system(cmd)
