KEYS = 
  ENTER: 13
  
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
    parsed = parseTokens tokens
    result = evalExpression parsed
    if result? then inputArea.value += '\n'+result.toString()
        
newLine = (event) ->
  if event.keyCode is KEYS.ENTER
    inputArea = document.getElementById 'inputArea'
    inputArea.value += "$ "