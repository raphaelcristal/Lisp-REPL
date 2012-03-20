KEYS = ENTER: 13
GLOBALS =
  '+': (x) => x.reduce (a,b) -> a + b 
  '-': (x) => x.reduce (a,b) -> a - b
  '*': (x) => x.reduce (a,b) -> a * b
  '/': (x) => x.reduce (a,b) -> a / b
  'define': (x) => 
    GLOBALS[x[0]]=x[1]
    return
  
window.onload = =>
  inputArea = document.getElementById 'inputArea'
  inputArea.onkeydown = checkInput
  inputArea.onkeyup = newLine
  inputArea.focus()
  inputArea.setSelectionRange 2,2

checkInput = (event) -> 
  if event.keyCode is KEYS.ENTER
    inputArea = document.getElementById 'inputArea'
    lines = inputArea.value.split '\n' 
    lastLine = lines[lines.length-1]
    lastLine = lastLine.replace '\$ ', ''
    if lastLine is 'clear'
      inputArea.value = ''
      return
    
    tokens = tokenize lastLine
    parsed = evalTokens tokens
    result = evalExpression parsed
    if result? then inputArea.value += '\n'+result
        
newLine = (event) ->
  if event.keyCode is KEYS.ENTER
    inputArea = document.getElementById 'inputArea'
    inputArea.value += "$ "


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
  

  