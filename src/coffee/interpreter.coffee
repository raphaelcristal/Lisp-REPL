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
  'cons': (x) -> new Lisp.Cons x[0], x[1]

class Environment
  constructor: (parms=[], args=[], @parent=null) ->
    for parm,index in parms
      @[parm.value] = args[index]
    
  find: (value) ->
    if value of @ then @ else @parent.find value
  
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
          env[variable.value] = evalExpression expr, env
        when 'lambda'
          [_, variables, expr] = expression
          new Lisp.Procedure 'lambda',
            (args) -> evalExpression expr, new Environment variables, args, env
        else #run procedure
          evaluated = (evalExpression x,env for x in expression)
          procedure = evaluated.shift()
          procedure(evaluated)
    else if expression.type is 'Symbol'
      env.find(expression.value)[expression.value]
    else
      expression
    
window.evalExpression = evalExpression
window.globalEnvironment = globalEnvironment