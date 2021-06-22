## doconce_tests
This repository contains a test suite and is a [git-submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules) of the [DocOnce](https://github.com/doconce/doconce) project. 


# Table of Contents
- [Synching tests in doconce](#synching-tests-in-doconce)
- [Requirements](#requirements)
- [Tests for DocOnce](#tests-for-doconce)
  * [tests.py](#testspy)
  * [pytests.py](#pytestspy)
  * [test_mintest.py](#test_mintestpy)
- [Requirements](#requirements)
- [Notes](#notes)


### Synching tests in doconce
After cloning the main [doconce](https://github.com/doconce/doconce) repository, the content of this repository (and all other [git-submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules)) can be downloaded by running this command:

```
git submodule update --init
```

### Requirements
The basic requirements are listed for the main [doconce](https://github.com/doconce/doconce) repository. 
In addition, some tests are run using [Jupyter kernels](https://github.com/jupyter/jupyter/wiki/Jupyter-kernels), but only if their installation is detected. 

- Install the [bash kernel](https://github.com/takluyver/bash_kernel) for bash;
- Install the [IR kernel](https://irkernel.github.io/installation/) for R;
- Install the [IJulia Jupyter kernel](https://github.com/JuliaLang/IJulia.jl) for in Julia with `using Pkg; Pkg.add("IJulia");Pkg.build("IJulia")`.

You can list the currently installed kernels with this command: `jupyter kernelspec list`. 


### Tests for DocOnce
There are three types of tests:

 * regression suite in tests.py 
 * unit tests in pytests.py
 * unit tests in test_mintest.py

#### tests.py
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


#### pytests.py
The unit tests in pytests.py can be run by:

  pytest -v pytests.py

These tests are run in the GitHub Actions workflow on the 


#### test_mintest.py
The plain unit tests are in test_mintest.py (very minimalistic tests,
mainly to check that the installation of DocOnce itself is okay). Run
by

```
py.test test_mintest.py
```


### Requirements 
A complete installation of [DocOnce](https://github.com/doconce/doconce). 
In addition some tests are run on features not included in the DocOnce standard requirements, for example Jupyter Julia and Bash kernels. 


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