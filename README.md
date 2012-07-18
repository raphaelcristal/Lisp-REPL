Lisp Interpreter written in CoffeeScript
========================================

### Try it! ###
[Lisp-REPL](http://pjuhri.github.com/Lisp-REPL/)

### How to build ###
Install [nodejs](nodejs.org) and [npm](npmjs.org). Then install CoffeeScript with *npm install -g coffee-script* and run:

    cake build

### Tests ###
To run the tests you will need the [Jasmine BDD Testframework](http://pivotal.github.com/jasmine/).
Extract it to ./lib and run:

    cake test

To execute the tests open SpecRunner.html.

### How to use ###

This software has been tested with the latest versions of Chrome and Firefox. It may work in other browsers but it is not guaranteed.

Open index.html after the project was built. The interface consists of two windows:
The right window is the REPL, which takes a single expression as an input and evaluates it immediatly. The left window takes multiple expresssion as input and they will be evaluated as you click the _Run_ button. After that you will be able to access your defined functions through the REPL. To save and load your code snippets you can use the save and load buttons. To clear the global environment and reset the interpreter, you can just reload the page.

### Simple Examples ###

```Scheme
(+ 1 2 3 4)
(define a 5)
(define b '(1 2 3 4 5))
(define plusOne (lambda (x) (+ x 1)))
; alternative Syntax
(define (plusOne x) (+ x 1))
(plusOne 5)
```

Builtins
========

### Supported Datatypes ###

Following is a list of supported datatypes. This list will be expanded as more datatypes are implemented

* **Number**: floating point number
* **True**: boolean true
* **False**: boolean false
* **Nil**: empty list
* **Cons**: a pair of values
* **List**: linked cons, terminates with empty list (nil)
* **String**: mutable string
* **Symbol**: immutable string, there will be only one instace active of each Symbol during runtime, so that 'a and 'a are the same objects

### Introspection ###

* **type?**: type? ARG
* **print**: print ARGS*

*Examples*:
```Scheme
(type? 5) ; 'Number
(type? 'a) ; 'Symbol
(print 5 ) ; 5
```

### Mathematical Operators ###
All functions can be used with an arbitrary number of arguments.

* **Plus**: + ARGS*
* **Minus**: - ARGS*
* **Multiply**: * ARGS*
* **Divide**: / ARGS*

*Examples*:
```Scheme
(+ 1 2 3 4)
(/ (+ 1 2) (- 1 2) (* (+ 1 1) (* 1 2)))
```

### Logical Operators ###

* **and**: and ARGS*
* **or**: or ARGS*
* **not**: not ARG

*Examples*:
```Scheme
(and true true false) ;false
(or (eq? 1 1) (eq? 2 1) (eq? 'a 'a)) ;true
(not (eq? 1 1)) ; false
```

### Comparators ###

* **eq**: eq? ARG1 ARG2
* **lt**: < ARG1 ARG2
* **gt**: > ARG1 ARG2
* **le**: <= ARG1 ARG2
* **ge**: >= ARG1 ARG2

*Examples*:
```Scheme
(< 1 2 ) ;True
(eq? 'a 'a) ;True
(>= 1 2) ;False
```

### Lists and Cons ###

* **first**: first LIST/CONS
* **rest**: rest LIST/CONS
* **last**: last LIST

*Examples*:
```Scheme
(define a '(1 2 3 4 5))
(define b (cons 1 2))
(first a) ; 1
(first b) ; 1
(rest a) ; '(2 3 4 5)
(rest b) ; 2
(last a) ; 5
```

### Evironment manipulation ###

Assign a value to a variable with define:
```Scheme
; numeric value
(define a 5)
; lambda expression
(define myFunc (lambda (x) (* x x)))
; alternative lambda expression
(define (myFunc x) (* x x))
```

the short lambda define sytanx has also an implicit begin body and the result of the last expression
will be assigned to the variable. Read the object.lisp example to see how
this can help you with defining objects.
```Scheme
(define (myVar) (+ 1 2) (+ 2 3) (+ 5 5))
(myVar) ; 10
```

Create a local variable with let:
```Scheme
(define (myFunc x) (let ((a 1) (b 2)) (* a b x)))
```

Set a value to an already defined variable:
```Scheme
(define a 5)
(set! a 6)
```
### Flow Control ###

#### if CONDITION TRUE-EXPRESSION FALSE-EXPRESSION ####
Executes TRUE-EXPRESSION and returns it's result if the condition is true.
If the CONDITION is false the FALSE-EXPRESSION will be evaluated.
```Scheme
(if (eq? 1 1) (+ 1 1) (+ 2 2)); 2
(if (eq? 1 2) (+ 1 1) (+ 2 2)); 4
```

#### BEGIN EXPRESSION1 EXPRESSION2 ... ####
Evaluates all expressions in sequential order and returns the result of the last expression.
The alternative lambda syntax has an implicit begin in it's body, so that it is possible to
define objects.
```Scheme
(begin (+ 1 1) (+ 2 2) (+ 3 3)) ; 6
(define (myFunc a b) (+ 1 1) (* a b))
```
