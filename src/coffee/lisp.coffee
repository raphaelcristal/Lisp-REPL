Array::type = "JList"

class Lisp
  
Lisp.Arg = class
  constructor: (@value) ->
  type: 'Arg'
    
Lisp.Boolean = class
  constructor: (@value) ->
  toString: -> if @value then '#t' else '#f'
  type: 'Boolean'

Lisp.Cons = class
  constructor: (@first, @rest) ->
  toString: -> "'(#{@first.toString()} . #{@rest.toString()})"
  type: 'Cons'

Lisp.False = new Lisp.Boolean false

Lisp.Nil = class
  constructor: ->
    @value = null
  toString: -> 'Nil'
  type: 'Nil'
  
Lisp.Number = class
  constructor: (@value) ->
  toString: -> "#{@value}"
  type: 'Number'
  
Lisp.Procedure = (name, opt) ->
  opt.toString = -> "#<procedure:#{name}>"
  opt.type = 'Procedure'
  opt
  
Lisp.Symbol = class
  constructor: (value) ->
    @value = "#{value}"
  toString: -> "'#{@value}"
  type: 'Symbol'

Lisp.True = new Lisp.Boolean true

window.Lisp = Lisp

GLOBALS =
  '+': new Lisp.Procedure('+', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value + b.value)
  '-': new Lisp.Procedure('-', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value - b.value)
  '*': new Lisp.Procedure('*', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value * b.value)
  '/': new Lisp.Procedure('/', (args) -> 
        args.reduce (a,b) -> new Lisp.Number a.value / b.value)
  #'define': (x) => 
   # GLOBALS[x[0]]=x[1]
    #return
  

  

  

  