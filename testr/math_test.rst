.. Automatically generated Sphinx-extended reStructuredText file from DocOnce source
   (https://github.com/doconce/doconce/)

.. Document title:

How various formats can deal with LaTeX math
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:Authors: Hans Petter Langtangen
:Date: Jan 32, 2100

*Summary.* The purpose of this document is to test LaTeX math in DocOnce with
various output formats.  Most LaTeX math constructions are renedered
correctly by MathJax in plain HTML, but some combinations of
constructions may fail.  Unfortunately, only a subset of what works in
html MathJax also works in sphinx MathJax. The same is true for
markdown MathJax expresions (e.g., Jupyter notebooks).  Tests and
examples are provided to illustrate what may go wrong.

The recommendation for writing math that translates to MathJax in
html, sphinx, and markdown is to stick to the environments ``\[
... \]``, ``equation``, ``equation*``, ``align``, ``align*``, ``alignat``, and
``alignat*`` only. Test the math with sphinx output; if it works in that
format, it should work elsewhere too.

The current version of the document is translated from DocOnce source
to the format **sphinx**.

Test of equation environments
=============================

Test 1: Inline math
-------------------

We can get an inline equation
``$u(t)=e^{-at}$`` rendered as :math:`u(t)=e^{-at}`.

Test 2: A single equation with label
------------------------------------

An equation with number,

.. code-block:: latex

    !bt
    \begin{equation} u(t)=e^{-at} label{eq1a}\end{equation}
    !et

looks like

.. math::
   :label: _eq1a

         u(t)=e^{-at} 

Maybe this multi-line version is what we actually prefer to write:

.. code-block:: latex

    !bt
    \begin{equation}
    u(t)=e^{-at}
    label{eq1b}
    \end{equation}
    !et

The result is the same:

.. math::
   :label: _eq1b

        
        u(t)=e^{-at} 
        

We can refer to this equation through its label ``eq1b``: :eq:`_eq1b`.

Test 3: Multiple, aligned equations without label and number
------------------------------------------------------------

MathJax has historically had some problems with rendering many LaTeX
math environments, but the ``align*`` and ``align`` environments have
always worked.

.. code-block:: latex

    !bt
    \begin{align*}
    u(t)&=e^{-at}\\ 
    v(t) - 1 &= \frac{du}{dt}
    \end{align*}
    !et

Result:

.. math::
        \begin{align*}
        u(t)&=e^{-at}\\ 
        v(t) - 1 &= \frac{du}{dt}
        \end{align*}

Test 4: Multiple, aligned equations with label
----------------------------------------------

Here, we use ``align`` with user-prescribed labels:

.. code-block:: latex

    !bt
    \begin{align}
    u(t)&=e^{-at}
    label{eq2b}\\ 
    v(t) - 1 &= \frac{du}{dt}
    label{eq3b}
    \end{align}
    !et

Result:

.. math::
   :label: _eq2b

        
        u(t)=e^{-at}
        
        

.. math::
   :label: _eq3b

          
        v(t) - 1 = \frac{du}{dt}
        
        

We can refer to the last equations as the system :eq:`_eq2b`-:eq:`_eq3b`.


.. admonition:: Note: align/alignat environments with labels are anti-aligned in sphinx

   Actually, *sphinx does not support the align environment with labels*,
   such as we write above,
   but DocOnce splits in this case the equations into separate, single equations
   with labels. Hence the user can write one code with align and labels
   and have it automatically
   to work in latex, html, sphinx, notebooks, and other formats.
   The generated sphinx code in the present case is
   
   .. code-block:: rst
   
       .. math::
          :label: eq2b
       
               u(t)=e^{-at}
       
       
       .. math::
          :label: eq3b
       
               v(t) - 1 = \frac{du}{dt}




If DocOnce had not rewritten the equation it would be rendered in
sphinx as nicely aligned equations without numbers (i.e., as if
we had used the ``align*`` environment):

.. math::

        \begin{align}
        u(t)&=e^{-at}
        \\\ 
        v(t) - 1 &= \frac{du}{dt}
        \
        \end{align}

Test 5: Multiple, aligned equations without label
-------------------------------------------------

In LaTeX, equations within an ``align`` environment is automatically
given numbers.  To ensure that an html document with MathJax gets the
same equation numbers as its latex/pdflatex companion, DocOnce
generates labels in equations where there is no label prescribed. For
example,

.. code-block:: latex

    !bt
    \begin{align}
    u(t)&=e^{-at}
    \\ 
    v(t) - 1 &= \frac{du}{dt}
    \end{align}
    !et

is edited to something like

.. code-block:: latex

    !bt
    \begin{align}
    u(t)&=e^{-at}
    label{_auto5}\\ 
    v(t) - 1 &= \frac{du}{dt}
    label{_auto6}
    \end{align}
    !et

and the output gets the two equation numbered.
Note that in sphinx the alignment is removed and separate ``equation``
environments are used to get numbered equations in equation systems, cf. the
box above.

.. math::
   :label: _auto1

        
        u(t)=e^{-at}
        
        

.. math::
   :label: _auto2

          
        v(t) - 1 = \frac{du}{dt}
        
        

Test 6: Multiple, aligned equations with multiple alignments
------------------------------------------------------------

The ``align`` environment can be used with two ``&`` alignment characters, e.g.,

.. code-block:: latex

    !bt
    \begin{align}
    \frac{\partial u}{\partial t} &= \nabla^2 u, & x\in (0,L),
    \ t\in (0,T]\\ 
    u(0,t) &= u_0(x), & x\in [0,L]
    \end{align}
    !et

The result in sphinx becomes

.. math::
   :label: _auto3

        
        \frac{\partial u}{\partial t} = \nabla^2 u,  x\in (0,L),
        \ t\in (0,T]
        
        

.. math::
   :label: _auto4

          
        u(0,t) = u_0(x),  x\in [0,L]
        
        

In sphinx, all alignments are removed, so this double use of ``&``
results in ugly typesetting!

A better solution is usually to use an ``alignat`` environment:

.. code-block:: latex

    !bt
    \begin{alignat}{2}
    \frac{\partial u}{\partial t} &= \nabla^2 u, & x\in (0,L),
    \ t\in (0,T]\\ 
    u(0,t) &= u_0(x), & x\in [0,L]
    \end{alignat}
    !et

with the rendered result

.. math::
   :label: _auto5

        
        \frac{\partial u}{\partial t} = \nabla^2 u,  x\in (0,L),
        \ t\in (0,T]
        
        

.. math::
   :label: _auto6

          
        u(0,t) = u_0(x),  x\in [0,L]
        
        


.. admonition:: align/alignat environments with equation numbers are anti-aligned

   In the ``sphinx``, ``ipynb``, and ``pandoc`` output formats, DocOnce rewrites
   the equations in an ``alignat`` environment as individual equations in
   ``equation`` environments (or more precisely, ``sphinx`` can work with
   ``alignat*`` so only numbered ``alignat`` equations get rewritten as individual
   equations). If the alignment is somewhat important, try the best with a
   manual rewrite in terms of separate ``equation`` environments, and stick to
   ``align*`` and ``alignat*`` in ``sphinx``.




With ``alignat*`` in sphinx, the equations above are typeset nicely as

.. math::
        \begin{alignat*}{2}
        \frac{\partial u}{\partial t} &= \nabla^2 u, & x\in (0,L),
        \ t\in (0,T]\\ 
        u(0,t) &= u_0(x), & x\in [0,L]
        \end{alignat*}

Note that if DocOnce had not rewritten of the above equations, they would be
rendered similarly in sphinx as

.. math::

        \begin{alignat}{2}
        \frac{\partial u}{\partial t} &= \nabla^2 u, & x\in (0,L),
        \ t\in (0,T]\\ 
        u(0,t) &= u_0(x), & x\in [0,L]
        \end{alignat}

That is, the equation numbers are gone.

Test 7: Multiple, aligned eqnarray equations without label
----------------------------------------------------------

Let us try the old ``eqnarray*`` environment.

.. code-block:: latex

    !bt
    \begin{eqnarray*}
    u(t)&=& e^{-at}\\ 
    v(t) - 1 &=& \frac{du}{dt}
    \end{eqnarray*}
    !et

which results in

.. math::
        \begin{eqnarray*}
        u(t) &=  e^{-at}\\ 
        v(t) - 1  &=  \frac{du}{dt}
        \end{eqnarray*}

Test 8: Multiple, eqnarrayed equations with label
-------------------------------------------------

Here we use ``eqnarray`` with labels:

.. code-block:: latex

    !bt
    \begin{eqnarray}
    u(t)&=& e^{-at}
    label{eq2c}\\ 
    v(t) - 1 &=& \frac{du}{dt}
    label{eq3c}
    \end{eqnarray}
    !et

which results in

.. math::
        \begin{eqnarray}
        u(t) &=  e^{-at} \\ 
        v(t) - 1  &=  \frac{du}{dt} 
        \end{eqnarray}

Can we refer to the last equations as the system :eq:`_eq2c`-:eq:`_eq3c`
in the sphinx format?
No, unfortunately not. Sphinx cannot deal with equation numbers in
``eqnarray`` environments and typeset them as if they were ``eqnarray*``.
But MathJax supports ``eqnarray`` with labels.
The rule of thumb is to use ``align`` and not ``eqnarray``!

Test 9: The ``multiline`` environment with label and number
-----------------------------------------------------------

The LaTeX code

.. code-block:: latex

    !bt
    \begin{multline}
    \int_a^b f(x)dx = \sum_{j=0}^{n} \frac{1}{2} h(f(a+jh) +
    f(a+(j+1)h)) \\ 
    =\frac{h}{2}f(a) + \frac{h}{2}f(b) + \sum_{j=1}^n f(a+jh)
    label{multiline:eq1}
    \end{multline}
    !et

gets rendered as

.. math::
   :label: _multiline:eq1

        
        \int_a^b f(x)dx = \sum_{j=0}^{n} \frac{1}{2} h(f(a+jh) +
        f(a+(j+1)h)) \\ 
        =\frac{h}{2}f(a) + \frac{h}{2}f(b) + \sum_{j=1}^n f(a+jh)
        
        

and we can hopefully refer to the Trapezoidal rule
as the formula :eq:`_multiline:eq1`.

This equation will not render in sphinx unless we remove the ``multiline``
environment, which means that it was typeset here without any multiline
information.
The best cross-format solution is to use ``align`` instead of ``multiline``
with ``\nonumber`` in the first equation!

Test 10: Splitting equations using a split environment
------------------------------------------------------

Although ``align`` can be used to split too long equations, a more obvious
command is ``split``:

.. code-block:: latex

    !bt
    \begin{equation}
    \begin{split}
    \int_a^b f(x)dx = \sum_{j=0}^{n} \frac{1}{2} h(f(a+jh) +
    f(a+(j+1)h)) \\ 
    =\frac{h}{2}f(a) + \frac{h}{2}f(b) + \sum_{j=1}^n f(a+jh)
    \end{split}
    \end{equation}
    !et

The result becomes

.. math::
   :label: _auto7

        
        \begin{split}
        \int_a^b f(x)dx = \sum_{j=0}^{n} \frac{1}{2} h(f(a+jh) +
        f(a+(j+1)h)) \\ 
        =\frac{h}{2}f(a) + \frac{h}{2}f(b) + \sum_{j=1}^n f(a+jh)
        \end{split}
        
        

Test 11: Newcommands and boldface bm vs pmb
-------------------------------------------

First we use the plain old pmb package for bold math. The formula

.. code-block:: latex

    !bt
    \[ \frac{\partial\u}{\partial t} +
    \u\cdot\nabla\u = \nu\nabla^2\u -
    \frac{1}{\varrho}\nabla p,\]
    !et

and the inline expression ``$\nabla\pmb{u} (\pmb{x})\cdot\pmb{n}$``
(with suitable newcommands using pmb)
get rendered as

.. math::
         \frac{\partial\pmb{u}}{\partial t} +
        \pmb{u}\cdot\nabla\pmb{u} = \nu\nabla^2\pmb{u} -
        \frac{1}{\varrho}\nabla p,

and :math:`\nabla\pmb{u} (\pmb{x})\cdot\pmb{n}`.
DocOnce replaces newcommands by the actual latex code when requesting
the sphinx output format.

Somewhat nicer fonts may appear with the more modern ``\bm`` command:

.. code-block:: latex

    !bt
    \[ \frac{\partial\ubm}{\partial t} +
    \ubm\cdot\nabla\ubm = \nu\nabla^2\ubm -
    \frac{1}{\varrho}\nabla p,\]
    !et

(backslash ``ubm`` is a newcommand for bold math :math:`u`), for which we get

.. math::
         \frac{\partial\boldsymbol{u}}{\partial t} +
        \boldsymbol{u}\cdot\nabla\boldsymbol{u} = \nu\nabla^2\boldsymbol{u} -
        \frac{1}{\varrho}\nabla p.

Moreover,

.. code-block:: text

    $\nabla\boldsymbol{u}(\boldsymbol{x})\cdot\boldsymbol{n}$

becomes :math:`\nabla\boldsymbol{u}(\boldsymbol{x})\cdot\boldsymbol{n}`.


.. warning::
    Note: for the sphinx format, ``\bm`` was substituted by DocOnce
    to ``\boldsymbol``.




Problematic equations
=====================

Finally, we collect some problematic formulas in MathJax. They all work
fine in LaTeX. Most of them look fine in html too, but some fail in
sphinx, ipynb, or markdown.

Colored terms in equations
--------------------------

The LaTeX code

.. code-block:: latex

    !bt
    \[ {\color{blue}\frac{\partial\u}{\partial t}} +
    \nabla\cdot\nabla\u = \nu\nabla^2\u -
    \frac{1}{\varrho}\nabla p,\]
    !et

results in

.. math::
         {\color{blue}\frac{\partial\pmb{u}}{\partial t}} +
        \nabla\cdot\nabla\pmb{u} = \nu\nabla^2\pmb{u} -
        \frac{1}{\varrho}\nabla p,

but correct rendering in sphinx requires omitting the ``\color`` command:

.. math::
         \frac{\partial\pmb{u}}{\partial t} +
        \nabla\cdot\nabla\pmb{u} = \nu\nabla^2\pmb{u} -
        \frac{1}{\varrho}\nabla p,

Bar over symbols
----------------

Sometimes one must be extra careful with the LaTeX syntax to get sphinx MathJax
to render a formula correctly. Consider the combination of a bar over a
bold math symbol:

.. code-block:: latex

    !bt
    \[ \bar\f = f_c^{-1}\f,\]
    !et

which for sphinx output results in

.. math::
         \bar\boldsymbol{f} = f_c^{-1}\boldsymbol{f}.

With sphinx, this formula is not rendered. However, using curly braces for the bar,

.. code-block:: latex

    !bt
    \[ \bar{\f} = f_c^{-1}\f,\]
    !et

makes the output correct also for sphinx:

.. math::
         \bar{\boldsymbol{f}} = f_c^{-1}\boldsymbol{f},

Matrix formulas
---------------

Here is an ``align`` environment with a label and the ``pmatrix``
environment for matrices and vectors in LaTeX.

.. code-block:: latex

    !bt
    \begin{align}
    \begin{pmatrix}
    G_2 + G_3 & -G_3 & -G_2 & 0 \\ 
    -G_3 & G_3 + G_4 & 0 & -G_4 \\ 
    -G_2 & 0 & G_1 + G_2 & 0 \\ 
    0 & -G_4 & 0 & G_4
    \end{pmatrix}
    &=
    \begin{pmatrix}
    v_1 \\ 
    v_2 \\ 
    v_3 \\ 
    v_4
    \end{pmatrix}
    + \cdots
    label{mymatrixeq}\\ 
    \begin{pmatrix}
    C_5 + C_6 & -C_6 & 0 & 0 \\ 
    -C_6 & C_6 & 0 & 0 \\ 
    0 & 0 & 0 & 0 \\ 
    0 & 0 & 0 & 0
    \end{pmatrix}
    \frac{d}{dt} &=
    \begin{pmatrix}
    v_1 \\ 
    v_2 \\ 
    v_3 \\ 
    v_4
    \end{pmatrix} =
    \begin{pmatrix}
    0 \\ 
    0 \\ 
    0 \\ 
    -i_0
    \end{pmatrix}
    \end{align}
    !et

which becomes

.. math::
   :label: _mymatrixeq

        
        \begin{pmatrix}
        G_2 + G_3 & -G_3 & -G_2 & 0 \\ 
        -G_3 & G_3 + G_4 & 0 & -G_4 \\ 
        -G_2 & 0 & G_1 + G_2 & 0 \\ 
        0 & -G_4 & 0 & G_4
        \end{pmatrix}
        =
        \begin{pmatrix}
        v_1 \\ 
        v_2 \\ 
        v_3 \\ 
        v_4
        \end{pmatrix}
        + \cdots
        
        

.. math::
   :label: _auto8

          
        \begin{pmatrix}
        C_5 + C_6 & -C_6 & 0 & 0 \\ 
        -C_6 & C_6 & 0 & 0 \\ 
        0 & 0 & 0 & 0 \\ 
        0 & 0 & 0 & 0
        \end{pmatrix}
        \frac{d}{dt} =
        \begin{pmatrix}
        v_1 \\ 
        v_2 \\ 
        v_3 \\ 
        v_4
        \end{pmatrix} =
        \begin{pmatrix}
        0 \\ 
        0 \\ 
        0 \\ 
        -i_0
        \end{pmatrix}
        
        

The same matrices without labels in an ``align*`` environment:

.. code-block:: latex

    !bt
    \begin{align*}
    \begin{pmatrix}
    G_2 + G_3 & -G_3 & -G_2 & 0 \\ 
    -G_3 & G_3 + G_4 & 0 & -G_4 \\ 
    -G_2 & 0 & G_1 + G_2 & 0 \\ 
    0 & -G_4 & 0 & G_4
    \end{pmatrix}
    &=
    \begin{pmatrix}
    v_1 \\ 
    v_2 \\ 
    v_3 \\ 
    v_4
    \end{pmatrix}
    + \cdots \\ 
    \begin{pmatrix}
    C_5 + C_6 & -C_6 & 0 & 0 \\ 
    -C_6 & C_6 & 0 & 0 \\ 
    0 & 0 & 0 & 0 \\ 
    0 & 0 & 0 & 0
    \end{pmatrix}
    \frac{d}{dt} &=
    \begin{pmatrix}
    v_1 \\ 
    v_2 \\ 
    v_3 \\ 
    v_4
    \end{pmatrix} =
    \begin{pmatrix}
    0 \\ 
    0 \\ 
    0 \\ 
    -i_0
    \end{pmatrix}
    \end{align*}
    !et

The rendered result becomes

.. math::
        \begin{align*}
        \begin{pmatrix}
        G_2 + G_3 & -G_3 & -G_2 & 0 \\ 
        -G_3 & G_3 + G_4 & 0 & -G_4 \\ 
        -G_2 & 0 & G_1 + G_2 & 0 \\ 
        0 & -G_4 & 0 & G_4
        \end{pmatrix}
        &=
        \begin{pmatrix}
        v_1 \\ 
        v_2 \\ 
        v_3 \\ 
        v_4
        \end{pmatrix}
        + \cdots \\ 
        \begin{pmatrix}
        C_5 + C_6 & -C_6 & 0 & 0 \\ 
        -C_6 & C_6 & 0 & 0 \\ 
        0 & 0 & 0 & 0 \\ 
        0 & 0 & 0 & 0
        \end{pmatrix}
        \frac{d}{dt} &=
        \begin{pmatrix}
        v_1 \\ 
        v_2 \\ 
        v_3 \\ 
        v_4
        \end{pmatrix} =
        \begin{pmatrix}
        0 \\ 
        0 \\ 
        0 \\ 
        -i_0
        \end{pmatrix}
        \end{align*}

