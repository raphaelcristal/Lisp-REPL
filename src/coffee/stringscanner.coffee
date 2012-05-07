tokenize = (string) ->
  #remove single line comments and whitespace
  string = string.replace /;+.+\n|\n|\r|\t/g, ' '
  string = string.replace /\(/g, ' ( '
  string = string.replace /\)/g, ' ) '
  #preserve quotes
  string = string.replace /'\s+\(/g, '\'('
  tokens = string.split ' '
  token for token in tokens when token isnt ''

parseTokens = (tokens) ->
  token = tokens.shift()
  if token is '('
    expression = []
    until tokens[0] is ')'
      expression.push parseTokens tokens
    tokens.shift()
    expression
  else if token is '\'('
    values = []
    until tokens[0] is ')'
      if tokens[0].charAt(0) isnt '\''
        #make sure. that every value in the list
        #is quoted if not a number
        tokens[0] = "'#{tokens[0]}"
      values.push parseTokens tokens
    tokens.shift()
    buildList(values)
  else
    parseValue(token)

parseValue = (value) ->
  if value is 'true' then return Lisp.True
  if value is 'false' then return Lisp.False
  if value is 'nil' then return Lisp.Nil
  asNumber = Number value.replace /^'/, ''
  if not isNaN asNumber
    return new Lisp.Number asNumber
  else if value.charAt(0) is '\''
    return new Lisp.Quoted value.replace /^'/, ''
  else
    return new Lisp.Symbol value.replace /^'/, ''

buildList = (values) ->
  if values.length is 0
    return Lisp.Nil
  else
    return new Lisp.Cons values.shift(), buildList(values)

#GLOBAL NAMESPACE
window.tokenize = tokenize
window.parseTokens = parseTokens
