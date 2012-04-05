Array::type = "JList"

Nil = class
  constructor: ->
    @value = null
  toString: -> '()'
  type: 'Nil'

class Lisp
  
Lisp.Boolean = class
  constructor: (@value) ->
  toString: -> if @value then '#t' else '#f'
  type: 'Boolean'

Lisp.Cons = class
  constructor: (@first, @rest) ->
  toString: -> "'(#{@first.toString()} . #{@rest.toString()})"
  type: 'Cons'

Lisp.False = new Lisp.Boolean false

Lisp.Nil = new Nil
  
Lisp.Number = class
  constructor: (@value) ->
  toString: -> "#{@value}"
  valueOf: -> @value
  type: 'Number'

Lisp.Quoted = class
  constructor: (@value) ->
  toString: -> "'#{@value}"
  type: 'Quoted'
  
Lisp.Procedure = (name, opt) ->
  opt.toString = -> "#<procedure:#{name}>"
  opt.type = 'Procedure'
  opt
  
Lisp.Symbol = class
  constructor: (value) ->
    @value = "#{value}"
  toString: -> @value
  type: 'Symbol'

Lisp.True = new Lisp.Boolean true

window.Lisp = Lisp
