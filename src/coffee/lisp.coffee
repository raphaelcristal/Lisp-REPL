Array::type = "JList"

listToString = (list) ->
  if list.rest is Lisp.Nil
    list.first
  else
    "#{list.first} #{listToString(list.rest)}"

typeCheck = (functionName, args, type) ->
  for arg,index in args
    if arg.type isnt type
      throw "#{functionName}: expects type <#{type}> as #{index+1} argument, given: #{arg.type}"

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
  Procedure: (name, type, opt) ->
    procedure = (args) ->
      if type isnt 'Any' then typeCheck name, args, type
      opt args
    procedure.toString = -> "#<procedure:#{name}>"
    procedure.type = 'Procedure'
    procedure
  Quoted: LispQuoted
  String: LispString
  Symbol: (s) -> symbolFactory.get s
  True: new LispBoolean true
