.. Automatically generated Sphinx-extended reStructuredText file from DocOnce source
   (https://github.com/doconce/doconce/)

HEADER
------

Then Cython (with -h option so it is hidden in html/sphinx):

.. container:: toggle

    .. container:: header

        **Show/Hide Code**

    .. code-block:: cython

        cpdef f(double x):
            return x + 1

This is a normal bash block using the ``sh`` environment

.. code-block:: sh

    if [ 1 -eq 0 ] ; then echo 1; fi

R code

.. code-block:: r

    x <- 1:6

Java code

.. code-block:: java

    for (int i = 0; i < 5; i++) {
      System.out.println(i);
    }

Javascript code

.. code-block:: js

    for (var x in [0,1,2]) {console.log(x)}

matlab code

.. code-block:: text

    for i = 1:2:10
      disp(A(i))
    end

html code

.. code-block:: html

    <a href='test'></a>

C code

.. code-block:: c

    #include <stdio.h>
    
    int main() {
      int i;
    
      for (i = 1; i < 11; ++i)
      {
        printf("%d ", i);
      }
      return 0;
    }

