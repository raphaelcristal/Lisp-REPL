Array::type = "JList"

listToString = (list) ->
  if list.rest is Lisp.Nil
    list.first
  else
    "#{list.first} #{listToString(list.rest)}"

class LispSymbol
  constructor: (value) ->
    @value = "#{value}"
  toString: -> "'#{@value}"
  type: 'Symbol'

class SymbolFactory
  get: (s) -> if s of @ then @[s] else @[s] = new LispSymbol(s)
symbolFactory = new SymbolFactory()

class LispNil
  constructor: ->
    @value = null
  toString: -> '\'()'
  type: 'Nil'

class LispBoolean
  constructor: (@value) ->
  toString: -> if @value then '#t' else '#f'
  type: 'Boolean'

class LispCons
  constructor: (@first, @rest) ->
  toString: -> if @.rest.type in ['Cons', 'Nil']
                "'(#{listToString(@)})"
               else
                "'(#{@first.toString()} . #{@rest.toString()})"
  type: 'Cons'

class LispNumber
  constructor: (@value) ->
  toString: -> "#{@value}"
  valueOf: -> @value
  type: 'Number'

class LispQuoted
  constructor: (@value) ->
  type: 'Quoted'

class LispString
  constructor: (@value) ->
  toString: -> "\"#{@value}\""
  valueOf: -> @value
  type: 'String'

window.Lisp =
  Cons: LispCons
  False: new LispBoolean false
  Nil: new LispNil
  Number: LispNumber
  Procedure: (name, opt) ->
    opt.toString = -> "#<procedure:#{name}>"
    opt.type = 'Procedure'
    opt
  Quoted: LispQuoted
  String: LispString
  Symbol: (s) -> symbolFactory.get s
  True: new LispBoolean true
