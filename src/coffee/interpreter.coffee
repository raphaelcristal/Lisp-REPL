typeCheck = (functionName, args, type) ->
  for arg,index in args
    if arg.type isnt type
      throw "#{functionName}: expects type <#{type}> as #{index} argument, given: #{arg.type}"

BUILTINS =
  '+': new Lisp.Procedure('+', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value + b.value)
  '-': new Lisp.Procedure('-', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value - b.value)
  '*': new Lisp.Procedure('*', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value * b.value)
  '/': new Lisp.Procedure('/', (args) ->
        args.reduce (a,b) -> new Lisp.Number a.value / b.value)
  '>': new Lisp.Procedure('>', (args) ->
        if args[0] > args[1] then Lisp.True else Lisp.False)
  '>=': new Lisp.Procedure('>=', (args) ->
        if args[0] >= args[1] then Lisp.True else Lisp.False)
  '<': new Lisp.Procedure('<', (args) ->
        if args[0] < args[1] then Lisp.True else Lisp.False)
  '<=': new Lisp.Procedure('<=', (args) ->
        if args[0] <= args[1] then Lisp.True else Lisp.False)
  'eq?': new Lisp.Procedure('eq?', (args) ->
        if args[0].type is 'Number'
          if args[0].value is args[1].value then return Lisp.True else return Lisp.False
        if args[0] is args[1] then Lisp.True else Lisp.False)
  'cons': new Lisp.Procedure('cons', (args) -> new Lisp.Cons args[0], args[1])
  'first': new Lisp.Procedure('first', (args) -> args[0].first)
  'rest': new Lisp.Procedure('rest', (args) -> args[0].rest)

class Environment
  constructor: (parms=[], args=[], @parent=null) ->
    for parm,index in parms
      @[parm.value] = args[index]
    
  find: (value) ->
    try
      if value of @ then @[value] else @parent.find value
    catch error
      throw "reference to undefined identifier: #{value}"
  
  updateValues: (values) ->
    for key,value of values
      @[key] = value
    

globalEnvironment = new Environment
globalEnvironment.updateValues BUILTINS
  
evalExpression = (expression, env=globalEnvironment) ->
    if expression.type is 'JList'
      switch expression[0].value
        when 'define'
          [_, variable, expr] = expression
          if variable.type is 'JList'
            #the alternative lambda syntax was used
            name = variable.shift()
            env[name.value] = new Lisp.Procedure name.value,
              (args) -> evalExpression expr, new Environment variable, args, env
          else
            env[variable.value] = evalExpression expr, env
        when 'lambda'
          [_, variables, expr] = expression
          new Lisp.Procedure 'lambda',
            (args) -> evalExpression expr, new Environment variables, args, env
        when 'if'
          [_, testExpr, ifExpr, elseExpr] = expression
          expr = if evalExpression(testExpr,env) is Lisp.True then ifExpr else elseExpr
          evalExpression expr, env
        else #run procedure
          evaluated = (evalExpression x,env for x in expression)
          procedure = evaluated.shift()
          procedure(evaluated)
    else if expression.type is 'Symbol'
      env.find(expression.value)
    else
      expression
    
window.evalExpression = evalExpression
window.globalEnvironment = globalEnvironment
window.resetGlobalEnvironment = ->
  globalEnvironment = new Environment
  globalEnvironment.updateValues BUILTINS
