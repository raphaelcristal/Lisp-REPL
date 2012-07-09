KEYS =
  BACKSPACE: 8
  ENTER: 13
  CTRL: 17
  LEFT: 37
  UP: 38
  C: 67


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
  $('#run').click splitExpression
  $('#save').popover
    placement: 'bottom'
    title: 'Choose a name'
    trigger: 'manual'
    content: '<input type="text" id="filename">'
  $('#save').click ->
    $(@).popover 'toggle'
    $('#filename').keydown saveCode

saveCode = (e) ->
  if e.which is KEYS.ENTER
    filename = $(@)
    code = $('#input').val()
    localStorage.setItem filename.val(), code
    filename.val ''
    $('#save').popover 'hide'

splitExpression = ->
  expressions = $('#input').val()
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
  lastKey = undefined
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
          cache = "#{history.slice(0, history.lastIndexOf(lastLine))}> #{lastCache.trim()}"
          repl.val cache
          currentCacheIndex -= 1
        e.preventDefault()
      when KEYS.LEFT
        checkForEnd()
      when KEYS.BACKSPACE
        checkForEnd()
      when KEYS.ENTER
        lastLine = repl.val().split('\n').pop()
        lastLine = lastLine.replace '> ', ''
        expressionLines.push lastLine+ ' '
        completeExpression = expressionLines.reduce (a,b) -> a + b
        if isBracketBalanced completeExpression
          expressionCache.push completeExpression
          currentCacheIndex = expressionCache.length - 1
          tokens = tokenize completeExpression
          parsed = parseTokens tokens
          try
            result = evalExpression parsed
            if result? then repl.val "#{history}\n#{result.toString()}"
          catch error
            repl.val "#{history}\n#{error.toString()}"
          newLine = true
          expressionLines = []
      when KEYS.C
        if lastKey is KEYS.CTRL
          e.preventDefault()
          repl.val history + '\n> '
          expressionLines = []
    lastKey = e.which

keyUp = (e) ->
  repl = $ '#console'
  if newLine
    history = repl.val()
    repl.val history + '> '

isBracketBalanced = (string) ->
  openingBrackets = string.split('(').length - 1
  closingBrackets = string.split(')').length - 1
  openingBrackets <= closingBrackets
