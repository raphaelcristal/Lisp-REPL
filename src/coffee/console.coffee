KEYS =
  ENTER: 13

window.onload = =>
  scriptInput = document.getElementById 'scriptInput'
  inputArea = document.getElementById 'console'
  parseButton = document.getElementById 'parse'
  bodyHeight = document.body.offsetHeight
  scriptInput.style.height = "#{bodyHeight/2}px"
  inputArea.style.height = "#{bodyHeight/2}px"
  parseButton.onclick = splitExpression
  inputArea.onkeydown = keyDown
  inputArea.onkeyup = keyUp
  inputArea.focus()
  inputArea.setSelectionRange 2,2

splitExpression = ->
  expressions = document.getElementById('scriptInput').value
  k = 0
  expressionStart = 0
  openBrackets = 0
  closedBrackets = 0
  expressionList = []
  while k < expressions.length
    if expressions.charAt(k) is '('
      openBrackets += 1
      if openBrackets is 1 and closedBrackets is 0
        expressionStart = k
    if expressions.charAt(k) is ')' then closedBrackets += 1
    k += 1
    if openBrackets > 0 and openBrackets is closedBrackets
      expr = expressions.slice expressionStart, k
      expressionList.push expr
      openBrackets = 0
      closedBrackets = 0
  for expr in expressionList
    evalExpression parseTokens tokenize expr
  return



expressionLines = []
newLine = false
keyDown = (event) ->
  newLine = false
  inputArea = document.getElementById 'console'
  if event.keyCode is KEYS.ENTER
    lines = inputArea.value.split '\n'
    lastLine = lines[lines.length-1]
    lastLine = lastLine.replace '\$ ', ''
    if lastLine is 'clear'
      inputArea.value = ''
      return

    expressionLines.push lastLine+' '
    completeExpression = expressionLines.reduce (a,b) -> a + b
    if isCommasBalanced completeExpression
      tokens = tokenize completeExpression
      parsed = parseTokens tokens
      try
        result = evalExpression parsed
        if result? then inputArea.value += '\n'+result.toString()
      catch error
        inputArea.value += '\n'+error.toString()
      expressionLines = []
      newLine = true

keyUp = (event) ->
  inputArea = document.getElementById 'console'
  if event.keyCode is KEYS.ENTER and newLine
    inputArea.value += "$ "

isCommasBalanced = (string) ->
  openingCommas = string.split('(').length - 1
  closingCommas = string.split(')').length - 1
  openingCommas is closingCommas
