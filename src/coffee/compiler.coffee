functions =
  'cons': (ast) ->
    "[].concat(#{compile ast[0]}, #{compile ast[1]})"
  '+': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} + #{compile b}"})"
  '-': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} - #{compile b}"})"
  '*': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} * #{compile b}"})"
  '/': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} / #{compile b}"})"
  'eq?': (ast) ->
    "__EQ(#{compile ast[0]}, #{compile ast[1]})"
  '<': (ast) ->
    "(#{compile ast[0]} < #{compile ast[1]})"
  '>': (ast) ->
    "(#{compile ast[0]} > #{compile ast[1]})"
  '>=': (ast) ->
    "(#{compile ast[0]} >= #{compile ast[1]})"
  '<=': (ast) ->
    "(#{compile ast[0]} <= #{compile ast[1]})"
  'not': (ast) ->
    "!(#{compile ast[0]})"
  'and': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} && #{compile b}"})"
  'or': (ast) ->
    "(#{ast.reduce (a,b) -> "#{compile a} || #{compile b}"})"
  'first': (ast) ->
    "#{compile ast[0]}[0]"
  'rest': (ast) ->
    "#{compile ast[0]}.slice(1)"
  'last': (ast) ->
    "#{compile ast[0]}.slice(-1)[0]"
  'define': (ast) ->
    if ast[0].type is 'JList'
      #alternative lambda syntax was used
      res = "var #{compile ast[0][0]} = function("
      #contains the function name and parameters
      tmp = ast[0][1..]
      #no parameters given
      if tmp.length is 0
        compile ast[0][0]
      #only one parameter, no reduce required
      else if tmp.length is 1
        res += compile ast[0][1]
      #multiple parameters
      else
        res += tmp.reduce (a,b) -> "#{compile a}, #{compile b}"
      res += ') {\n'
      ast[1..].forEach (item, index, array) ->
        if index is array.length-1
          res += "\treturn #{compile item};\n"
        else
          res += "\t#{compile item};\n"
      res += '};'
      res
    else
      "var #{compile ast[0]} = #{compile ast[1]};"
  'set!': (ast) ->
    "#{compile ast[0]} = #{compile ast[1]};"
  'lambda': (ast) ->
    if ast[0].length is 0
      parms = ''
    else if ast[0].length is 1
      parms = compile ast[0][0]
    else if ast[0].length > 1
      parms = ast[0].reduce (a,b) -> "#{compile a}, #{compile b}"

    "function(#{parms}) " +
      "{\n" +
        "\treturn #{compile ast[1]};\n" +
      "}"
  'begin': (ast) ->
    res = "(function() {\n"
    console.log ast.length
    if ast.length is 1
      res += "\treturn #{compile ast[0]};\n"
    else
      res += ast.reduce (a,b,i,c) ->
        if i is c.length-1
          "\t#{compile a};\n\treturn #{compile b};"
        else
          "#{compile a};\n\t#{compile b}"
    res += "\n})();"
  'if': (ast) ->
    "(#{compile ast[0]}) ? #{compile ast[1]} : #{compile ast[2]}"
  'print': (ast) ->
    "console.log(#{compile ast[0]});"
  'let': (ast) ->
    res = "(function() { "
    ast[0].forEach (i) ->
      res += "var #{compile i[0]} = #{compile i[1]}; "
    res += "return #{compile ast[1]}; })()"
    res

buildArray = (cons) ->
  if cons.rest.type isnt 'Nil'
    "#{compile cons.first}, #{buildArray cons.rest}"
  else
    "#{compile cons.first}"

compile = (ast) ->
  switch ast.type
    when 'JList'
      if ast[0].value of functions
        functions[ast[0].value](ast[1..])
      else
        rest = ast[1..]
        if rest.length is 0
          "#{compile ast[0]}()"
        else if rest.length is 1
          "#{compile ast[0]}(#{compile rest[0]})"
        else
          "#{compile ast[0]}(#{ast[1..].reduce (a,b) -> "#{compile a}, #{compile b}"})"
    when 'Symbol'
      ast.toString().slice 1
    when 'Boolean'
      ast.value.toString()
    when 'Quoted'
      if ast.value.type is 'Cons'
        "[#{buildArray ast.value}]"
      #javascript has no symbols, treat them like normal strings
      else if ast.value.type is 'Symbol'
        '"' + ast.value.value + '"'
      else
        compile ast.value
    when 'Nil'
      '[]'
    else
      ast.toString()



# EXPORTS
window.Compiler =
  compile: compile
