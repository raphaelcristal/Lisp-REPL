KEYS =
  ENTER: 13
  BACKSPACE: 8
  
window.onload = =>
  inputArea = document.getElementById 'inputArea'
  inputArea.onkeydown = keyDown
  inputArea.onkeyup = keyUp
  inputArea.focus()
  inputArea.setSelectionRange 2,2
  
keyDown = (event) ->
  inputArea = document.getElementById 'inputArea'
  if event.keyCode is KEYS.ENTER
    lines = inputArea.value.split '\n'
    lastLine = lines[lines.length-1]
    lastLine = lastLine.replace '\$ ', ''
    if lastLine is 'clear'
      inputArea.value = ''
      return
    
    tokens = tokenize lastLine
    parsed = parseTokens tokens
    console.log parsed
    result = evalExpression parsed
    console.log result
    if result? then inputArea.value += '\n'+result.toString()
        
keyUp = (event) ->
  inputArea = document.getElementById 'inputArea'
  if event.keyCode is KEYS.BACKSPACE
    if inputArea.selectionStart is 1
      inputArea.value += ' '
      inputArea.setSelectionRange 2,2
    if inputArea.selectionStart is 0
      inputArea.value += '$ '
      inputArea.setSelectionRange 2,2
  if event.keyCode is KEYS.ENTER
    inputArea.value += "$ "
