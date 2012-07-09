KEYS =
  BACKSPACE: 8
  ENTER: 13
  LEFT: 37
  UP: 38


$ ->
  input = $ '#input'
  repl = $ '#console'
  navbar = $ '#navbar'
  buttonGroup = $ '#button-group'
  win = $ window
  inputHeight = win.height() - (navbar.height() + buttonGroup.height()) - 50
  input.height inputHeight
  repl.height inputHeight
  repl.val '> '
  repl.keydown keyDown
  repl.keyup keyUp
  repl.mousedown mouseDown


  ###
  parseButton = document.getElementById 'parse'
  parseButton.onclick = splitExpression
  ###

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



# LISTENERS

mouseDown = (e) ->
  repl = $ '#console'
  e.preventDefault()
  textlength = repl.val().length
  if not repl.is ':focus'
    repl.setCursorPosition textlength, textlength


newLine = false
keyDown = do ->
  expressionLines = []
  expressionCache = []
  currentCacheIndex = 0
  (e) ->
    newLine = false
    repl = $ '#console'
    history = repl.val()
    checkForEnd = ->
      position = repl.getCursorPosition()
      if position <= 2 or history.slice(position-3, position) is '\n> '
        e.preventDefault()

    switch e.which
      when KEYS.UP
        if currentCacheIndex is -1
          currentCacheIndex = expressionCache.length - 1
        lastCache = expressionCache[currentCacheIndex]
        if lastCache
          lastLine = repl.val().split('\n').pop()
          cache = "#{history.slice(0, history.lastIndexOf(lastLine))}> #{lastCache}"
          repl.val cache
          currentCacheIndex -= 1
        e.preventDefault()
      when KEYS.LEFT
        checkForEnd()
      when KEYS.BACKSPACE
        checkForEnd()
      when KEYS.ENTER
        newLine = true
        lastLine = repl.val().split('\n').pop()
        lastLine = lastLine.replace '> ', ''
        expressionCache.push lastLine
        currentCacheIndex = expressionCache.length - 1
        tokens = tokenize lastLine
        parsed = parseTokens tokens
        try
          result = evalExpression parsed
          if result? then repl.val "#{history}\n#{result.toString()}"
        catch error
          repl.val "#{history}\n#{error.toString()}"

  ###
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
   ###
keyUp = (e) ->
  repl = $ '#console'
  if e.which is KEYS.ENTER and newLine
    history = repl.val()
    repl.val history + '> '

isBracketBalanced = (string) ->
  openingBrackets = string.split('(').length - 1
  closingBrackets = string.split(')').length - 1
  openingBrackets is closingBrackets
