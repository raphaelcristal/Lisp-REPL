Lisp Interpreter written in CoffeeScript
========================================

### Try it! ###
[Lisp-REPL](http://pjuhri.github.com/Lisp-REPL/)

[Video Tutorial](http://youtu.be/o-cqbVpyqSA)
Change quality to HD!

### How to build ###
Install [nodejs](nodejs.org) and [npm](npmjs.org). Then install CoffeeScript with *npm install -g coffee-script* and run:

    cake build

### Libraries ###
The following libraries are needed and should be extracted to ./lib

* [Jasmine BDD Testframework](http://pivotal.github.com/jasmine/) Version: 1.2
* [JQuery](http://jquery.com/) Version: 1.7.3
* [Bootstrap](http://twitter.github.com/bootstrap/) Version: 2.0.4

### Tests ###
Build the tests with

    cake test

then open SpecRunner.html.

### Project Structure ###

* console.js: UI Behaviour
* compiler.js: Experimental Lisp to Javascript Compiler
* helperFunctions: helper functions for compiled javascript
* interpreter.js: builtins and eval method
* lisp.js: lisp datatypes
* position.js: helper functions for html textarea
* stringscanner.js: tokenizer and ast builder

### How to use ###

This software has been tested with the latest versions of **Chrome** and **Firefox**. It may work in other browsers but it is not guaranteed.

Open index.html after the project was built. The interface consists of two windows:
The right window is the REPL, which takes a single expression as an input and evaluates it immediatly. The left window takes multiple expresssion as input and they will be evaluated as you click the _Run_ button. After that you will be able to access your defined functions through the REPL. To save and load your code snippets you can use the save and load buttons. To clear the global environment and reset the interpreter, you can just reload the page. The _Compile_ Button will compile your Lisp to Javscript. You can find more information about the compiler [here](#BLA).

The interactive console on the right supports a few keyboard shortcuts you can use

* **UP** cycle through your last inputs
* **CTRL+C** abort the current input

The console also detects when your expression is complete by counting the brackets. So there is no need to enter your whole expression before you press enter. If you made a mistake just use CTRL+C to abort the current input.

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
### Exceptions ###

The interpreter throws several exceptions:

*"reference to undefined identifier: `<identifier>`"*
There was no variable with the identifier `<identifier>`

*"set!: cannot set variable before its definition: `<identifier>`"*
set! can only be used with an already defined variable

*"`<function>`: expects type `<type>` as `<index>` argument, given: `<type>`"*
the function was called with a wrong type, for example (+ 'a "b")

Builtins
========

### Supported Datatypes ###

Following is a list of supported datatypes.

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

The short lambda define sytanx has also an implicit begin body and the result of the last expression
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


# Experimental Lisp to Javascript Compiler #
This project also includes a very experimental Lisp to Javascript Compiler. Although it compiles
valid JavaScript there are serveral problems why it should not be used for anything:
* JavaScript intendation is *interesting*
* Semicolon insertion is broken, code works only because of JavaScript's ASI (Automatic Semicolon Insertion)
* No errors whatsoever. Incorrect Lisp Syntax will result in an **empty output!** So count your brackets carefully!
* Generated code is not very readable and therefore hard to debug

How to use:
Just type your Lisp code in the left window and press the compile button. The result will be pasted into the same window.
There are also several examples in examples/Compiler.
