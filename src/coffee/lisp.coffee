###
  Lisp Datatypes
  LispNil:      maps to Javascript's null
  LispTrue:     maps to JavaScript's True
  LispFalse:    maps to JavaScript's False
  LispNumber:   maps to JavaScript's Number
  LispSymbol:   maps to JavaScript's String, will not be evaluated
  LispCons:     holds a pair of data, first and rest   
###

LispNil = ->
   @toString -> "Nil"
  
GLOBALS =
  '+': (x) => x.reduce (a,b) -> a + b 
  '-': (x) => x.reduce (a,b) -> a - b
  '*': (x) => x.reduce (a,b) -> a * b
  '/': (x) => x.reduce (a,b) -> a / b
  'define': (x) => 
    GLOBALS[x[0]]=x[1]
    return
  

  

  

  