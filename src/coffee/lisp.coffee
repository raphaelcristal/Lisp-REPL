class Lisp
  
Lisp.Boolean = class
  constructor: (@value) ->
  toString: -> if @value then '#t' else '#f'

Lisp.Cons = class
  constructor: (@first, @rest) ->
  toString: -> "'(#{@first.toString()} . #{@rest.toString()})"

Lisp.False = new Lisp.Boolean false

Lisp.Nil = class
  constructor: ->
    @value = null
  toString: -> 'Nil'
  
Lisp.Number = class
  constructor: (@value) ->
  toString: -> "#{@value}"
  
Lisp.Procedure = (name, opt) ->
  opt.toString = -> "#<procedure:#{name}>"
  opt
  
Lisp.Symbol = class
  constructor: (value) ->
    @value = "#{value}"
  toString: -> "'#{@value}"

Lisp.True = new Lisp.Boolean true

window.Lisp = Lisp

###  
GLOBALS =
  '+': (x) => x.reduce (a,b) -> a + b 
  '-': (x) => x.reduce (a,b) -> a - b
  '*': (x) => x.reduce (a,b) -> a * b
  '/': (x) => x.reduce (a,b) -> a / b
  'define': (x) => 
    GLOBALS[x[0]]=x[1]
    return
###
  

  

  

  