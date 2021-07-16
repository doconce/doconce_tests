#!/bin/bash -x
#set -x
#export PS4='+ l.${LINENO}: ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
bold=$(tput bold)
red=$(tput setaf 1)
reset=$(tput sgr0)
function system {
  "$@"
  if [ $? -ne 0 ]; then
    echo -e "\nmake.sh: unsuccessful command ${bold}${red}$@${reset}"
    echo "abort!"
    exit 1
  fi
}

rm -rf html_images reveal.js downloaded_figures latex_styles

# Note:  --examples_as_exercises is required to avoid abortion

# Make publish database
rm -rf papers.pub  venues.list # clean

publish import refs1.bib <<EOF
1
2
EOF
if [ $? -ne 0 ]; then echo "make.sh: abort"; exit 1; fi

publish import refs2.bib <<EOF
2
2
EOF
# Simulate that we get new data, which is best put
# in a new file
publish import refs3.bib <<EOF
1
2
y
1
EOF

system doconce spellcheck -d .dict4spell.txt _testdoc.do.txt



## Test --execute
system doconce format html execute.do.txt --execute
#system doconce format ipynb execute.do.txt --execute
system doconce format latex execute.do.txt --execute
doconce ptex2tex execute.p.tex



## Test ipynb
system doconce format ipynb execute.do.txt --examples_as_exercises
system doconce format ipynb execute.do.txt --examples_as_exercises --execute 
system doconce format latex execute.do.txt --examples_as_exercises
system doconce format latex execute.do.txt --examples_as_exercises --execute 
system doconce format html execute.do.txt  --examples_as_exercises
system doconce format html execute.do.txt  --examples_as_exercises --execute 



## Test html
system doconce format html testdoc --wordpress  --examples_as_exercises --html_exercise_icon=question_blue_on_white1.png --html_exercise_icon_width=80 --figure_prefix="https://raw.githubusercontent.com/doconce/doconce_tests/main/" --movie_prefix="https://raw.githubusercontent.com/doconce/doconce_tests/main/" --html_links_in_new_window --cite_doconce --output=testdoc_wordpress

system doconce format html testdoc --without_answers --without_solutions --examples_as_exercises -DSOMEVAR --html_exercise_icon=default --solutions_at_end --html_share=https://cyber.space.com/specials,twitter,print,google+,facebook,linkedin
system doconce format html testdoc --without_answers --without_solutions --examples_as_exercises --html_exercise_icon=default --answers_at_end --solutions_at_end --html_share=https://cyber.space.com/specials,twitter,print,google+,facebook,linkedin --output=testdoc_no_solutions

system doconce split_html testdoc_no_solutions.html --method=space10

system doconce format html testdoc --examples_as_exercises  # just produce the mako file
system doconce extract_exercises tmp_mako__testdoc.do.txt --exercise_numbering=section --filter=ipynb

system doconce format latex testdoc --without_answers --without_solutions --examples_as_exercises -DSOMEVAR --sections_down --number_all_equations --latex_packages=varioref --cite_doconce --output=testdoc_no_solutions

cp ../bundled/html_styles/style_vagrant/template_vagrant.html .
system doconce format html testdoc.do.txt --examples_as_exercises --html_style=bootstrap --html_template=template_vagrant.html --html_toc_indent=0 --toc_depth=2 --output=testdoc_vagrant

# Test that a split of testdoc_vagrant.html becomes correct
system doconce split_html testdoc_vagrant.html --method=split #creates ._testdoc_vagrant00[0-2].html

system doconce apply_inline_edits testdoc.do.txt
system doconce format html testdoc.do.txt --pygments_html_linenos --html_style=solarized --pygments_html_style=emacs --examples_as_exercises --html_exercise_icon=exercise1.svg
mv .testdoc_html_file_collection .testdoc1_html_file_collection

system doconce remove_exercise_answers testdoc.html
system doconce html_colorbullets testdoc.html
system doconce split_html testdoc.html --nav_button=gray2,bottom --font_size=slides

system doconce format html testdoc.do.txt --pygments_html_linenos --html_style=solarized --pygments_html_style=emacs --examples_as_exercises --output=demo_testdoc



## Test latex
system doconce format latex testdoc.do.txt --examples_as_exercises SOMEVAR=True --skip_inline_comments --latex_packages=varioref

# pdflatex: testdoc.tex_direct
# Test lst with external and internal styles
system doconce format pdflatex testdoc.do.txt --examples_as_exercises "--latex_code_style=default:lst-blue1[style=myspeciallststyle,numbers=left,numberstyle=\\tiny,stepnumber=3,numbersep=15pt,xleftmargin=1mm]@fcod:vrb-gray@sys:vrb[frame=lines,label=\\fbox{{\\tiny Terminal}},framesep=2.5mm,framerule=0.7pt]" --latex_code_lststyles=mylststyles --latex_packages=varioref

# Issue #9: removed "style=redblue"
cp testdoc.tex testdoc.tex_direct

# pdflatex: testdoc_bigex
system doconce format pdflatex testdoc.do.txt --device=paper --examples_as_exercises --latex_double_hyphen --latex_index_in_margin --latex_no_program_footnotelink --latex_title_layout=titlepage --latex_papersize=a4 --latex_colored_table_rows=blue --latex_fancy_header --latex_section_headings=blue --latex_labels_in_margin --latex_double_spacing --latex_todonotes --latex_list_of_exercises=loe --latex_font=palatino --latex_packages=varioref '--latex_link_color=blue!90' --draft --output=testdoc_bigex
# --latex_paper=a4 triggers summary environment to be smaller paragraph
# within the text (fine for proposals or articles).
# Drop the table exercise toc since we want to test loe above
#system doconce latex_exercise_toc testdoc_bigex
# doconce replace does not work well with system bash func above without quotes
doconce replace 'vspace{1cm} % after toc' 'clearpage % after toc' testdoc_bigex.p.tex
# can drop usepackage{theorem} since we have user-defined envir with amsthm
doconce subst '(newtheorem\{example\}.*)' '\g<1>\n\\newtheorem{theorem}{Theorem}[section]' testdoc_bigex.p.tex
doconce subst '\\paragraph\{Theorem \d+\.\}' '' testdoc_bigex.p.tex
doconce replace '% begin theorem' '\begin{theorem}' testdoc_bigex.p.tex
doconce replace '% end theorem' '\end{theorem}' testdoc_bigex.p.tex
# because of --latex-double-hyphen:
doconce replace Newton--Cotes Newton-Cotes testdoc_bigex.p.tex
doconce replace --examples_as__exercises --examples_as_exercises testdoc_bigex.p.tex
system doconce ptex2tex testdoc_bigex.p.tex #testdoc.tex

# test that pdflatex works
rm -f *.aux
system pdflatex -shell-escape -halt-on-error testdoc_bigex.tex
pdflatex -shell-escape -halt-on-error testdoc_bigex.tex
makeindex testdoc_bigex.tex
bibtex testdoc_bigex.tex
pdflatex -shell-escape -halt-on-error testdoc_bigex.tex
pdflatex -shell-escape -halt-on-error testdoc_bigex.tex
pdflatex -shell-escape -halt-on-error testdoc_bigex.tex

cp testdoc_bigex.tex testdoc.tex
cp testdoc_bigex.p.tex testdoc.p.tex

system doconce ptex2tex testdoc "sys=\begin{Verbatim}[frame=lines]@\end{Verbatim}" pypro=ans:nt envir=minted > testdoc.tex_doconce_ptex2tex
echo "----------- end of doconce ptex2tex output ----------------" >> testdoc.tex_doconce_ptex2tex
cat testdoc.tex >> testdoc.tex_doconce_ptex2tex
# Test that latex can treat this file
rm -f *.aux
system pdflatex -shell-escape -halt-on-error testdoc.tex



# Test stand-alone exercises
system doconce format plain testdoc --exercises_in_zip --examples_as_exercises
rm -rf standalone_exercises
unzip testdoc_exercises.zip
cd standalone_exercises
python make.py
cd ..



## Test jupyterbook
system doconce jupyterbook testdoc --show_titles --sep=section --dest=$PWD --dest_toc=$PWD --examples_as_exercises --allow_refs_to_external_docs

system doconce jupyterbook testdoc --show_titles --sep=section --sep_section=subsection --titles=README.md --examples_as_exercises --allow_refs_to_external_docs 

system doconce jupyterbook testdoc --show_titles --sep=section --sep_section=subsection --dest=$PWD --dest_toc=$PWD --examples_as_exercises --allow_refs_to_external_docs



# Test prefix
system doconce format html testdoc --code_prefix=$PWD --output=testdoc_code_prefix --examples_as_exercises

system doconce format plain testdoc.do.txt --examples_as_exercises -DSOMEVAR=1 --tables2csv
system doconce format st testdoc.do.txt --examples_as_exercises

system doconce format sphinx testdoc --examples_as_exercises --html_links_in_new_window --output=testdoc.sphinx
cp testdoc.sphinx.rst testdoc.rst 
system doconce split_rst testdoc.rst
# Problem reproducible after: `git clean -fd && rm -rf sphinx-testdoc`
#Hack: because doconce sphinx_dir ony works the second time (after an error), trigger that error by creating a bogus conf.py in ./
touch conf.py 
system doconce sphinx_dir dirname='sphinx-testdoc' version=0.1 theme=agni testdoc
cp automake_sphinx.py automake_sphinx_testdoc.py 
system python automake_sphinx.py
cp sphinx-testdoc/conf.py testdoc_sphinx_conf.py
cp sphinx-testdoc/index.rst testdoc_sphinx_index.rst



## Test misc formats
system doconce format rst testdoc.do.txt --examples_as_exercises --rst_mathjax

system doconce format epytext testdoc.do.txt --examples_as_exercises
system doconce format pandoc testdoc.do.txt --examples_as_exercises
system doconce format mwiki testdoc.do.txt --examples_as_exercises
system doconce format cwiki testdoc.do.txt --examples_as_exercises
system doconce format ipynb testdoc.do.txt --examples_as_exercises
system doconce format matlabnb testdoc.do.txt --examples_as_exercises
# Test mako variables too
system doconce format gwiki testdoc.do.txt --skip_inline_comments MYVAR1=3 MYVAR2='a string' --examples_as_exercises



## Test pandoc: from latex to markdown, from markdown to html
system doconce format latex testdoc.do.txt --examples_as_exercises --latex_title_layout=std --latex_packages=varioref
system doconce ptex2tex testdoc
#doconce subst -s 'And here is a system of equations with labels.+?\\section' '\\section' testdoc.tex
# pandoc cannot work well with \Verb, needs \verb
system doconce replace '\Verb!' '\verb!' testdoc.tex
# pandoc v 10 does not handle a couple of the URLs
doconce replace '%E2%80%93' '' testdoc.tex
doconce replace '+%26+' '' testdoc.tex

#system pandoc -f latex -t markdown -o testdoc.md testdoc.tex
#system pandoc -f markdown -t html -o testdoc_pnd_l2h.html --mathjax -s testdoc.md
#pandoc -v >> testdoc_pnd_l2h.html

system doconce format pandoc testdoc.do.txt --examples_as_exercises
#system pandoc -t html -o testdoc_pnd_d2h.html --mathjax -s testdoc.md
#pandoc -v >> testdoc_pnd_d2h.html



## Test slides
# slides1: rough small test
# slides2: much of scientific_writing.do.txt
# slides3: equal to slides/demo.do.txt

system doconce format html slides1 --pygments_html_style=perldoc --keep_pygments_html_bg
cp slides1.html slides1_1st.html
system doconce slides_html slides1 reveal --html_slide_themee=simple

cp slides1.html slides1_reveal.html
/bin/ls -R reveal.js >> slides1_reveal.html

system doconce format html slides1 --pygments_html_style=emacs --keep_pygments_html_bg
system doconce slides_html slides1 deck --html_slide_theme=web-2.0

cp slides1.html slides1_deck.html
/bin/ls -R deck.js >> slides1_deck.html

system doconce format markdown slides1 --github_md --pygments_html_style=emacs
system doconce slides_markdown slides1 remark --slide_theme=light
cp slides1.html slides1_remark.html

# The toughest test of slides1 is with minted code envir
rm -f *.aux
system doconce format pdflatex slides1 --latex_title_layout=beamer --latex_code_style=pyg --cite_doconce
system doconce slides_beamer slides1.tex --beamer_slide_theme=blue_shadow --handout
system pdflatex -shell-escape -halt-on-error slides1.tex
cp slides1.tex slides1_handout.tex
cp slides1.pdf slides1_handout.pdf

# Ordinary beamer slides (not handout)
system doconce format pdflatex slides1 --latex_title_layout=beamer "--latex_code_style=default:lst[style=yellow2_fb]"
system doconce slides_beamer slides1.tex --beamer_slide_theme=blue_shadow
system pdflatex -shell-escape -halt-on-error slides1.tex

system doconce format html slides2 --pygments_html_style=emacs --no_abort
system doconce slides_html slides2 reveal --html_slide_theme=beigesmall
cp slides2.html slides2_reveal.html

rm -f *.aux
system doconce format pdflatex slides2 --latex_title_layout=beamer -DBEAMER --no_abort
system doconce ptex2tex slides2 envir=minted
system doconce slides_beamer slides2.tex

system doconce format html slides3 --pygments_html_style=emacs SLIDE_TYPE=reveal SLIDE_THEME=beigesmall
system doconce slides_html slides3 reveal --html_slide_type=beigesmall
cp slides3.html slides3_reveal.html

system doconce format html slides3 --html_style=solarized3 SLIDE_TYPE=doconce SLIDE_THEME=solarized3 --output=slides3-solarized3
system doconce slides_html slides3-solarized3 doconce --nav_button=bigblue,bottom --font_size=slides

rm -f *.aux
system doconce format pdflatex slides3 SLIDE_TYPE=beamer SLIDE_THEME=red_plain --latex_title_layout=beamer
system doconce ptex2tex slides3 envir=minted
system doconce slides_beamer slides3.tex --beamer_slide_theme=red_plain

system doconce format html slides1 --pygments_html_style=emacs
system doconce slides_html slides1 all



## Test grab
system doconce grab --from- '={5} Subsection 1' --to 'subroutine@' _testdoc.do.txt > testdoc.tmp
doconce grab --from 'Compute a Probability' --to- 'drawing uniformly' _testdoc.do.txt >> testdoc.tmp
doconce grab --from- '\*\s+\$.+normally' _testdoc.do.txt >> testdoc.tmp



## Test html templates
system doconce format html html_template --html_template=template1.html --pygments_html_style=none
cp html_template.html html_template1.html

system doconce format html html_template --html_template=template_inf1100.html  --pygments_html_style=emacs



## Test author special case and generalized references
system doconce format html author1
system doconce format latex author1
system doconce format sphinx author1
system doconce format plain author1

# Test journal styles
system doconce format pdflatex author2 --latex_style=siamltex
system doconce ptex2tex author2
cp author2.tex author2_siamltex.tex
system doconce format pdflatex author2 --latex_style=elsevier
system doconce ptex2tex author2
cp author2.tex author2_elsevier.tex



## Test notebook conversions
cp ../doc/src/ipynb/example.do.txt nbdemo.do.txt
doconce replace 'fig/oscillator_general' '../doc/src/ipynb/fig/oscillator_general' nbdemo.do.txt
system doconce format ipynb nbdemo.do.txt
system doconce ipynb2doconce nbdemo.ipynb --output=nbdemo_ipynb2doconce.do.txt
#TODO: issues with references to figures, which are formatted as normal links
#but should be rendered with ref{label}. This causes error with this command:
#system doconce format ipynb nbdemo_ipynb2doconce.do.txt --output nbdemo_ipynb2doconce.ipynb



## Test math
rm -f *.aux
system doconce format pdflatex math_test --no_abort
system doconce ptex2tex math_test
pdflatex math_test
system doconce format html math_test --no_abort
cp math_test.html math_test_html.html
system doconce format sphinx math_test --no_abort
system doconce sphinx_dir dirname=sphinx-rootdir-math math_test
cp automake_sphinx.py automake_sphinx_math_test.py
python automake_sphinx.py
system doconce format pandoc math_test --no_abort
# Do not use pandoc directly because it does not support MathJax sufficiently well
system doconce md2html math_test.md --no_abort
cp math_test.html math_test_pandoc.html
system doconce format pandoc math_test --no_abort
system doconce md2latex math_test

# Test all types of copyright syntax
python test_copyright.py  # results in test_copyright.out

# Test tailored conf.py file
system doconce format sphinx copyright COPYRIGHT='{copyright,date}' BOOK=False
system doconce split_rst copyright
system doconce sphinx_dir short_title="Really short title" conf.py=myconf.py copyright
system python automake_sphinx.py
cp sphinx-rootdir/conf.py tailored_conf.py



## Test admonitions
# LaTeX admon styles
admon_tps="colors1 mdfbox paragraph-footnotesize graybox2 yellowicon grayicon colors2"
for admon_tp in $admon_tps; do
  color=
  opts=
  if [ $admon_tp = 'mdfbox' ]; then
     color="--latex_admon_color=warning:darkgreen!40!white;notice:darkgray!20!white;summary:tucorange!20!white;question:red!50!white;block:darkgreen!40!white"
     opts=--no_abort
  elif [ $admon_tp = 'grayicon' ]; then
     color="--latex_admon_color=gray!20"
  elif [ $admon_tp = 'graybox2' ]; then
     opts=--no_abort
  fi
  system doconce format pdflatex admon --latex_admon=$admon_tp $color $opts --latex_code_style=lst --cite_doconce
  cp admon.tex admon_${admon_tp}.tex
  # Make a substitution to fix a problem with `pdflatex admon_colors1`
  doconce subst '\\\\paragraph{Hint.}\\n' '\paragraph{Hint.}' admon_${admon_tp}.tex

  system pdflatex admon_${admon_tp}.tex
  echo "admon=$admon_tp"
  if [ -d latex_figs ]; then
      echo "latex_figs:"
      /bin/ls latex_figs
  else
      echo "no latex_figs directory for this admon type"
  fi
  rm -rf latex_figs
done

# Test different code envirs inside admons
system doconce format pdflatex admon --latex_admon=mdfbox --latex_admon_color=1,1,1 --latex_admon_envir_map=2 --cite_doconce --no_abort
system doconce ptex2tex admon pycod2=minted pypro2=minted pycod=Verbatim pypro=Verbatim
cp admon.tex admon_double_envirs.tex
rm -rf latex_figs

# Test HTML admon styles
system doconce format html admon --html_admon=lyx --html_style=blueish2 --cite_doconce
cp admon.html admon_lyx.html

system doconce format html admon --html_admon=paragraph --html_style=blueish2 --cite_doconce
cp admon.html admon_paragraph.html

system doconce format html admon --html_admon=colors --cite_doconce
cp admon.html admon_colors.html

system doconce format html admon --html_admon=gray --html_style=blueish2 --html_admon_shadow --html_box_shadow --cite_doconce
cp admon.html admon_gray.html

system doconce format html admon --html_admon=yellow --html_admon_shadow --html_box_shadow --cite_doconce
cp admon.html admon_yellow.html

system doconce format html admon --html_admon=apricot --html_style=solarized --cite_doconce
cp admon.html admon_apricot.html

system doconce format html admon --html_style=bootstrap --pygments_html_style=default --html_template=../bundled/html_styles/style_vagrant/template_vagrant.html --cite_doconce
cp admon.html admon_vagrant.html

system doconce format html admon --html_style=bootstrap --pygments_html_style=default --html_admon=bootstrap_alert --cite_doconce "--html_bootstrap_navbar_links=Google|https://google.com;DocOnce formats|https://hplgit.github.io/teamods/writing_reports/index.html"
cp admon.html admon_bootstrap_alert.html
system doconce split_html admon_bootstrap_alert.html --pagination --nav_button=top+bottom

system doconce format html admon --html_style=bootswatch --pygments_html_style=default --html_admon=bootstrap_panel --cite_doconce
cp admon.html admon_bootswatch_panel.html

system doconce sphinx_dir dirname=tmp_admon admon
system python automake_sphinx.py
rm -rf admon_sphinx
cp -r tmp_admon/_build/html admon_sphinx

system doconce format mwiki admon --cite_doconce
cp admon.mwiki admon_mwiki.mwiki

system doconce format plain admon --cite_doconce
cp admon.txt admon_paragraph.txt

cp -fr admon_*.html admon_*.pdf admon_*.*wiki admon_*.txt ._admon_*.html admon_sphinx admon_demo/
cd admon_demo
doconce replace '../doc/src/manual/fig/wave1D' '../../doc/src/manual/fig/wave1D' *.html .*.html
rm -rf *~
cd ..

#google-chrome admon_*.html
#for pdf in admon_*.pdf; do evince $pdf; done

if [ -d latex_figs ]; then
    echo "BUG: latex_figs was made by some non-latex format..."
fi



## Test styles
# Bootstrap HTML styles
system doconce format html test_boots --html_style=bootswatch_journal --pygments_html_style=default --html_admon=bootstrap_panel --html_code_style=inherit
system doconce split_html test_boots.html

# GitHub-extended Markdown
system doconce format pandoc github_md.do.txt --github_md

# Markdown input
system doconce format html markdown_input.do.txt --markdown --md2do_output=mdinput2do.do.txt



## Test movie handling
system doconce format html movies --output=movies_3choices
cp movies_3choices.html movie_demo
system doconce format html movies --no_mp4_webm_ogg_alternatives
cp movies.html movie_demo

rm -f movies.aux
system doconce format pdflatex movies --latex_movie=media9
system doconce ptex2tex movies
system pdflatex movies.tex
pdflatex movies
cp movies.pdf movie_demo/movies_media9.pdf
cp movies.tex movies_media9.tex

system doconce format pdflatex movies --latex_movie=media9 --latex_external_movie_viewer
system doconce ptex2tex movies
system pdflatex movies.tex
cp movies.pdf movie_demo/movies_media9_extviewer.pdf

# multimedia (beamer \movie command) does not work well
#rm movies.aux

rm -f movies.aux
system doconce format pdflatex movies
system doconce ptex2tex movies
system pdflatex movies.tex
cp movies.pdf movie_demo

system doconce format plain movies



## Test locale support
cp ../doc/src/locale/locale.do.txt .
system doconce format html locale --html_style=bootstrap_FlatUI --language=Norwegian --encoding=utf-8
system doconce format pdflatex locale --latex_code_style=vrb --language=Norwegian --encoding=utf-8
# locale does not exist
#pdflatex locale
#makeindex locale
#pdflatex locale
#pdflatex locale

cd Springer_T2
bash -x make.sh
cd ..

doconce subst -m '^.*? (AM|PM) - ' '' automake_sphinx.log

# Status movies: everything works in html and sphinx, only href works
# in latex, media9 is unreliable



## Test encoding
# guess and change
system doconce format html encoding1   --no_header_footer
system doconce guess_encoding encoding1.do.txt > tmp_encodings.txt
cp encoding1.do.txt tmp1.do.txt
system doconce change_encoding utf-8 latin1 tmp1.do.txt
system doconce guess_encoding tmp1.do.txt >> tmp_encodings.txt
system doconce change_encoding latin1 utf-8 tmp1.do.txt
system doconce guess_encoding tmp1.do.txt >> tmp_encodings.txt
system doconce guess_encoding encoding2.do.txt >> tmp_encodings.txt
cp encoding1.do.txt tmp2.do.txt
system doconce change_encoding utf-8 latin1 tmp2.do.txt
system doconce guess_encoding tmp2.do.txt >> tmp_encodings.txt

# Handle encoding problems (and test debug output too)
# Plain ASCII with Norwegian chars printed as is (and utf8 package mode)
system doconce format latex encoding3 --debug --no_header_footer
cp encoding3.p.tex encoding3.p.tex-ascii
# Plain ASCII text with Norwegian chars coded as &#...;
system doconce format html encoding3 --pygments_html_style=off --debug --no_header_footer
cp encoding3.html encoding3.html-ascii
cat _doconce_debugging.log >> encoding3.html-ascii

# Plain ASCII with verbatim blocks with Norwegian chars
system doconce format latex encoding3 -DPREPROCESS --no_header_footer  # preprocess handles utf-8
cp encoding3.p.tex encoding3.p.tex-ascii-verb
system doconce format html encoding3 -DPREPROCESS --no_header_footer  # html fails with utf-8 in !bc
# Unicode with Norwegian chars in plain text and verbatim blocks
system doconce format html encoding3 -DPREPROCESS  --encoding=utf-8  --pygments_html_style=none --debug --no_header_footer # Keeps Norwegian chars since output is in utf-8
cp encoding3.html encoding3.html-ascii-verb
cat _doconce_debugging.log >> encoding3.html-ascii-verb

system doconce format latex encoding3 -DMAKO --no_header_footer  # mako fails due to Norwegian chars
# Unicode with Norwegian chars in plain text and verbatim blocks
system doconce format latex encoding3 -DMAKO --encoding=utf-8 --no_header_footer  # utf-8 and unicode
cp encoding3.p.tex encoding3.p.tex-utf8
system doconce format html encoding3 -DMAKO --encoding=utf-8 --pygments_html_style=off --debug --no_header_footer
cp encoding3.html encoding3.html-utf8
cat _doconce_debugging.log >> encoding3.html-utf8



## Test mako problems
system doconce format html mako_test1 --pygments_html_style=off  --no_header_footer  # mako variable only, no % lines
system doconce format html mako_test2 --pygments_html_style=off  --no_header_footer  # % lines inside code, but need for mako
system doconce format html mako_test3 --pygments_html_style=off  --no_header_footer  # % lines inside code
cp mako_test3.html mako_test3b.html
system doconce format html mako_test3 --pygments_html_style=none  --no_header_footer # no problem message
system doconce format html mako_test4 --pygments_html_style=no  --no_header_footer   # works fine, lines start with %%

system doconce csv2table testtable.csv > testtable.do.txt

# Test doconce ref_external command
# Cannot find these scripts in repo anymore
#sh -x genref.sh



## Test error detection
# (note: the sequence of the error tests is crucial: 
# an error must occur, then corrected before the next one will occur!)
cp failures.do.txt tmp2.do.txt
doconce format plain tmp2.do.txt
doconce replace '`myfile.py` file' '`myfile.py`' tmp2.do.txt

doconce subst 'failure\}\n\n!bc' 'failure}\n\nHello\n!bc' tmp2.do.txt
doconce format sphinx tmp2.do.txt
doconce replace '!bsubex' '' tmp2.do.txt
doconce format sphinx tmp2.do.txt
doconce replace '# Comment before list' '' tmp2.do.txt
doconce format sphinx tmp2
doconce replace '\idx' 'idx' tmp2.do.txt
doconce replace '\cite' 'cite' tmp2.do.txt
doconce format rst tmp2
doconce subst -s '__Paragraph before.+!bc' '!bc' tmp2.do.txt
doconce format rst tmp2
doconce replace '\label' 'label' tmp2.do.txt
doconce replace 'wave1D width' 'wave1D,  width' tmp2.do.txt
doconce format sphinx tmp2
doconce replace 'doc/manual' 'doc/src/manual' tmp2.do.txt
doconce format sphinx tmp2
doconce replace '../lib/doconce/doconce.py' '_static/doconce.py' tmp2.do.txt
doconce replace 'two_media99' 'two_media' tmp2.do.txt
doconce format html tmp2
doconce replace '|--l---|---l---|' '|--l-------l---|' tmp2.do.txt
doconce format html tmp2
doconce replace '99x9.ogg' '.ogg' tmp2.do.txt
doconce format html tmp2
doconce subst -s -m '^!bsol.+?!esol' ''  tmp2.do.txt
doconce format sphinx tmp2
doconce subst -s -m '^!bhint.+?!ehint' ''  tmp2.do.txt
doconce format sphinx tmp2
doconce format pdflatex tmp2 --device=paper
# Remedy: drop paper and rewrite, just run electronic
system doconce format pdflatex tmp2
#doconce replace '# Comment before math is ok' '' tmp2.do.txt



## Remove some files
rm -rf 0*md 0*ipynb *~ 
echo ""
echo "When we reach this point in the script,"
echo "it is clearly a successful run of all tests!"
echo ""
