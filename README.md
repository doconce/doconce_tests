## doconce_tests
This repository contains tests suite for [DocOnce](https://github.com/doconce/doconce).

There are two types of tests:

 * tests.py regression suite
 * unit tests in test_mintest.py

##### tests.py
The first contains classical regression tests where text is
generated in many files, these are concatenated, and then
compared with the big reference file with name test.r.

This is run by:

```
python tests.py
```

A diff test.v test.r show differences of generated text
(test.v) and reference data (test.r). Don't run this unless you have
a complete installation with all the DocOnce dependencies.



##### test_mintest.py
The plain unit tests are in test_mintest.py (very minimalistic tests,
mainly to check that the installation of DocOnce itself is okay). Run
by

```
py.test test_mintest.py
```


### Notes

Note that standard unit tests with nose/pytest are less suitable for a
text transformation program such as DocOnce. The reason is that some
functionality must be tested in larger files where many constructions
play together. Also, test files are frequently changed to add new
constructions, or test the effect of bug fixes, leading to a substantial
evolution of the reference text. At least for a small project as
DocOnce, this has turned out to be the most feasible testing approach.
Basically, `python test.py` is run and `test.v` is compared against
`test.r` in a diff program, using the human eye (because many updates lead
to significant changes in the diff that require a human to approve).

Dependencies for the test problems run by test.py are
basically all software that DocOnce depends on, see
installation instructions in ../doc/pub/manual/manual.html.
