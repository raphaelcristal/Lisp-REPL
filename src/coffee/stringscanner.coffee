tokenize = (string) ->
  string = string.replace /\(/g, ' ( '
  string = string.replace /\)/g, ' ) '
  #preserve quotes
  string = string.replace /'\s+\(/g, '\'('
  tokens = string.split(' ')
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