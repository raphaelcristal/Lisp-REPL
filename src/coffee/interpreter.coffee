typeCheck = (functionName, args, type) ->
  for arg,index in args
    if arg.type isnt type
      throw "#{functionName}: expects type <#{type}> as #{index} argument, given: #{arg.type}"

BUILTINS =
  '+': new Lisp.Procedure('+', (args, env) ->
        args.reduce (a,b) -> new Lisp.Number eval(a, env) + eval(b, env))
  '-': new Lisp.Procedure('-', (args, env) ->
        args.reduce (a,b) -> new Lisp.Number eval(a, env) - eval(b, env))
  '*': new Lisp.Procedure('*', (args, env) ->
        args.reduce (a,b) -> new Lisp.Number eval(a, env) * eval(b, env))
  '/': new Lisp.Procedure('/', (args, env) ->
        args.reduce (a,b) -> new Lisp.Number eval(a, env) / eval(b, env))
  '>': new Lisp.Procedure('>', (args, env) ->
        if eval(args[0], env) > eval(args[1], env) then Lisp.True else Lisp.False)
  '>=': new Lisp.Procedure('>=', (args, env) ->
        if eval(args[0], env) >= eval(args[1], env) then Lisp.True else Lisp.False)
  '<': new Lisp.Procedure('<', (args, env) ->
        if eval(args[0], env) < eval(args[1], env) then Lisp.True else Lisp.False)
  '<=': new Lisp.Procedure('<=', (args, env) ->
        if eval(args[0], env) <= eval(args[1], env) then Lisp.True else Lisp.False)
  'eq?': new Lisp.Procedure('eq?', (args, env) ->
        if eval(args[0], env).type is 'Number'
          if eval(args[0], env).value is eval(args[1], env).value
            return Lisp.True
          else
            return Lisp.False
        if eval(args[0], env) is eval(args[1], env) then Lisp.True else Lisp.False)
  'cons': new Lisp.Procedure('cons', (args, env) ->
                                       new Lisp.Cons eval(args[0], env), eval(args[1], env))
  'first': new Lisp.Procedure('first', (args, env) -> eval(args[0], env).first)
  'rest': new Lisp.Procedure('rest', (args, env) -> eval(args[0], env).rest)
  'define': new Lisp.Procedure('define', (args, env) ->
              if args[0].type is 'JList'
                #alternative lambda syntax
                name = args[0].shift()
                args.unshift new Lisp.Symbol('lambda')
                args = [args]
              else
                name = args.shift()
              env[name.value] = eval args[0], env)
  'lambda': new Lisp.Procedure('lambda', (args, env) ->
              [parms,body] = args
              new Lisp.Procedure('UserDefined', (args) ->
                eval body, new Environment parms,args,env))
  'if': new Lisp.Procedure('if', (args, env) ->
          [condition,ifBlock,elseBlock] = args
          if eval(condition, env) is Lisp.True
            eval(ifBlock, env)
          else
            eval(elseBlock, env))
  'let': new Lisp.Procedure('let', (args, env) ->
            for x in args.shift()
              env[x[0].value] = x[1]
            eval args.shift(), env)

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
  
eval = (expression, env=globalEnvironment) ->
    if expression.type is 'JList'
      procedure = eval expression.shift(), env
      procedure expression, env
    else if expression.type is 'Symbol'
      env.find expression.value
    else
      expression
    
window.eval = eval
window.globalEnvironment = globalEnvironment
window.resetGlobalEnvironment = ->
  globalEnvironment = new Environment
  globalEnvironment.updateValues BUILTINS
