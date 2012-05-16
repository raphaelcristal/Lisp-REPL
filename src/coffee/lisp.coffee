Array::type = "JList"

listToString = (list) ->
  if list.rest is Lisp.Nil
    list.first
  else
    "#{list.first} #{listToString(list.rest)}"

class Symbol
  constructor: (value) ->
    @value = "#{value}"
  toString: -> "'#{@value}"
  type: 'Symbol'

class SymbolFactory
  get: (s) -> if s of @ then @[s] else @[s] = new Symbol(s)
symbolFactory = new SymbolFactory()

Nil = class
  constructor: ->
    @value = null
  toString: -> '\'()'
  type: 'Nil'

class Lisp

class Boolean
  constructor: (@value) ->
  toString: -> if @value then '#t' else '#f'
  type: 'Boolean'

Lisp.Cons = class
  constructor: (@first, @rest) ->
  toString: -> if @.rest.type in ['Cons', 'Nil']
                "'(#{listToString(@)})"
               else
                "'(#{@first.toString()} . #{@rest.toString()})"

  type: 'Cons'

Lisp.False = new Boolean false

Lisp.Nil = new Nil

Lisp.Number = class
  constructor: (@value) ->
  toString: -> "#{@value}"
  valueOf: -> @value
  type: 'Number'

Lisp.Quoted = class
  constructor: (@value) ->
  type: 'Quoted'

Lisp.Procedure = (name, opt) ->
  opt.toString = -> "#<procedure:#{name}>"
  opt.type = 'Procedure'
  opt

Lisp.Symbol = (s) -> symbolFactory.get s

Lisp.True = new Boolean true

window.Lisp = Lisp
