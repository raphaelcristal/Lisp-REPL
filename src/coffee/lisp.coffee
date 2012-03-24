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
  
tokenize = (string) ->
  withSpaces = string.replace /\(/g, ' ( '
  withSpaces = withSpaces.replace /\)/g, ' ) '
  tokens = withSpaces.split(' ')
  token for token in tokens when token isnt ''
  
evalTokens = (tokens) ->
  token = tokens.shift()
  if token is '('
    expression = []
    while tokens[0] isnt ')'
      expression.push evalTokens tokens
    tokens.shift() 
    expression
  else
    parseValue(token)
    
parseValue = (value) ->
  parsed = Number(value)
  if isNaN parsed
    return value
  parsed
  
evalExpression = (expression) ->
  switch typeof expression
    when 'object'
      exp = (evalExpression x for x in expression) 
      func = exp.shift()
      func(exp)
    when 'string'
      if expression of GLOBALS then return GLOBALS[expression]  
      expression
    when 'number' then expression
    else throw 'error' 
  

  