Lisp Interpreter written in CoffeeScript
========================================

### How to build
Install [nodejs](nodejs.org) and [npm](npmjs.org). Then install CoffeeScript with *npm install -g coffee-script* and run:

    cake build

### Tests
To run the tests you will need the [Jasmine BDD Testframework](http://pivotal.github.com/jasmine/).
Extract it to ./lib and run:

    cake test

To execute the tests open SpecRunner.html.

### How to use

Open index.html after the project was built. The interface consists of two windows:
The bottom window is the REPL, which takes a single expression as an input and evaluates it immediatly. The top window takes multiple expresssion as input and they will be evaluated as you click the _Parse_ button. After that you will be able to access your defined functions through the REPL. To clear the global environment and reset the interpreter, you can just reload the page.

### Simple Examples

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

### Supported Datatypes

Following is a list of supported datatypes. This list will be expanded as more datatypes are implemented

* **Number**: floating point number

* **True**: boolean true

* **False**: boolean false

* **Nil**: empty list

* **Cons**: a pair of values

* **List**: linked cons, terminates with empty list (nil)

* **Symbol**: immutable string, there will be only one instace active of each Symbol during runtime, so that 'a and 'a are the same objects

### Mathematical Operators
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

### Logical Operators

TODO

### Comparators

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

### Evironment manipulation
Assign a value to a variable with define:
```Scheme
; numeric value
(define a 5)
; lambda expression
(define myFunc (lambda (x) (* x x)))
; alternative lambda expression
(define (myFunc x) (* x x))
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
