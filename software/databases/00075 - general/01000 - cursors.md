# Cursors

* Allows you to iterate over a set of rows in a table or result set.

* steps
    * DECLARE CURSOR
    * OPEN CURSOR
        * loads the dataset into memory
    * FETCH CURSOR
        * loads row into variables
    * CLOSE CURSOR / DEALLOCATE CURSOR
        * frees the dataset from memory

* pros
    * allows you to iterate overs rows

* cons
    * very very slow (because it kills the work of an optimizer, that finds the best way to deal with a data set)

* alternatives
    * Window functions
        * OVER clause
    * Common Table Expressions (CTEs)
    * CASE statements

* keep cursor tool as a last resort