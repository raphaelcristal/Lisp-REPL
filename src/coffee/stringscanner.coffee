tokenize = (string) ->
  string = string.replace /\(/g, ' ( '
  string = string.replace /\)/g, ' ) '
  #preserve quotes
  string = string.replace /'\s+\(/g, '\'('
  tokens = string.split(' ')
  token for token in tokens when token isnt ''
  
parseTokens = (tokens) ->
  token = tokens.shift()
  if token is '('
    expression = []
    while tokens[0] isnt ')'
      expression.push parseTokens tokens
    tokens.shift() 
    expression
  else
    parseValue(token)
    
parseValue = (value) ->
  asNumber = Number(value)
  if not isNaN asNumber then return Lisp.Number asNumber
  if value is 'true' then return Lisp.True
  if value is 'false' then return Lisp.False
  if value.indexOf 0 is '\'' then return Lisp.Symbol value.replace "'", ''
  
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